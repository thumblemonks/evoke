require File.join(File.dirname(__FILE__), 'config', 'boot')
require 'sinatra'

configure(:development, :test) { require 'ruby-debug' }

configure do
  Thumblemonks::Database.fire_me_up(Sinatra.env)
end

# Setup

include Thumblemonks::Sinatra::Extensions

helpers do
  include Thumblemonks::Sinatra::Helpers
end

def manage_resource(resource)
  yield(resource)
  status(201)
  json_response(resource)
rescue ActiveRecord::RecordInvalid => e
  invalid_record(e.record)
end

# Actions

not_found do
  throw :halt, [404, json_response('')]
end

def invalid_record(record)
  # Need a simple logging facility
  # $stdout.puts "ERROR: record #{record.inspect} says #{record.errors.full_messages.inspect}"
  throw :halt, [422, json_response(:errors => record.errors.full_messages)]
end

# get "/callbacks/:guid" do
# end

post "/callbacks" do
  manage_resource(Callback.new(params)) do |callback|
    callback.save!
    job = Delayed::Job.enqueue(callback, 0, callback.callback_at)
    callback.update_attributes!(:delayed_job => job)
  end
end

put "/callbacks/:guid" do
  @callback = Callback.by_guid(params['guid'])
  raise Sinatra::NotFound unless @callback
  attributes = params.reject {|k,v| k == "guid"}
  manage_resource(@callback) do |callback|
    callback.delayed_job.destroy
    callback.update_attributes!(attributes)
    job = Delayed::Job.enqueue(callback, 0, callback.callback_at)
    callback.update_attributes!(:delayed_job => job)
  end
end
