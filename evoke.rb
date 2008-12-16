require File.join(File.dirname(__FILE__), 'config', 'boot')

configure(:development, :test) { require 'ruby-debug' }

error do
  $stdout.puts "Sorry there was a nasty error - #{request.env['sinatra.error'].inspect}"
end

# Resource management

not_found do
  throw :halt, [404, json_response('')]
end

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
    # job = Delayed::Job.enqueue(callback, 0, callback.callback_at)
    # callback.update_attributes!(:delayed_job => job)
  end
end

put "/callbacks/:guid" do
  manage_resource(Callback.by_guid(params['guid'])) do |callback|
    attributes = params.reject {|k,v| k == "guid"}
    callback.update_attributes!(attributes)
    CallbackRunner.replace_job_for_callback!(callback)
    # callback.delayed_job.destroy if callback.delayed_job
    # job = Delayed::Job.enqueue(callback, 0, callback.callback_at)
    # callback.update_attributes!(:delayed_job => job)
  end
end
