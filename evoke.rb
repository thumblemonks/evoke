require File.join(File.dirname(__FILE__), 'config', 'boot')

class Evoke < Sinatra::Base
  register Sinatra::Chicago
  helpers Sinatra::Chicago::Helpers
  helpers Sinatra::Chicago::Responders
  helpers Sinatra::Authorization

  error do
    $stdout.puts "Sorry there was a nasty error - #{request.env['sinatra.error'].inspect}"
  end

  # Resource management

  not_found { throw :halt, [404, json_response('')] }

  def valid_record(record)
    status(201)
    json_response(record)
  end

  def invalid_record(record)
    # Need a simple logging facility
    # $stdout.puts "ERROR: record #{record.inspect} says #{record.errors.full_messages.inspect}"
    throw :halt, [422, json_response(:errors => record.errors.full_messages)]
  end

  def manage_resource(resource)
    raise Sinatra::NotFound unless resource
    yield(resource) if block_given?
    valid_record(resource)
  rescue ActiveRecord::RecordInvalid => e
    invalid_record(e.record)
  end

  # Actions

  get "/callbacks/:guid" do
    manage_resource(Callback.by_guid(params['guid']))
  end

  post "/callbacks" do
    manage_resource(Callback.new(params)) do |callback|
      callback.save!
      CallbackRunner.make_job_from_callback!(callback)
    end
  end

  put "/callbacks/:guid" do
    manage_resource(Callback.by_guid(params['guid'])) do |callback|
      attributes = params.reject {|k,v| k == "guid"}
      callback.update_attributes!(attributes)
      CallbackRunner.replace_job_for_callback!(callback)
    end
  end

  #
  # Status and stuff

  catch_all_css

  helpers do
    def authorize(username, password)
      [username, password] == Configuration["authorization"].values_at("username", "password")
    end

    def truncate(str, n)
      str.length > n ? "#{str[0..n]}..." : str
    end

    def verbal_status_message(callback)
      if callback.called_back?
        haml '.okay Already evoked callback', :layout => false
      elsif callback.should_have_been_called_back? && !callback.called_back?
        haml '.uhoh This callback should have been evoked but has not yet', :layout => false
      else
        haml '.okay Just waiting for callback time', :layout => false
      end
    end
  end

  get "/status" do
    login_required
    @status = Status.new
    haml :status, :layout => :application
  end
end # Evoke
