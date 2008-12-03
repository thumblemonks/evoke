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
  if yield(resource)
    status(201)
    json_response(resource)
  else
    invalid_record(resource)
  end
end

# Actions

not_found do
  throw :halt, [404, json_response('')]
end

def invalid_record(record)
  throw :halt, [422, json_response(:errors => record.errors.full_messages)]
end

post("/callbacks") do
  manage_resource(Callback.new(params)) { |resource| resource.save }
end

put("/callbacks/:guid") do
  @callback = Callback.by_guid(params['guid'])
  raise Sinatra::NotFound unless @callback
  attributes = params.reject {|k,v| k == "guid"}
  manage_resource(@callback) { |resource| resource.update_attributes(attributes) }
end
