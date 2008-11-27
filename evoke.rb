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

# Actions

def invalid_record(record)
  throw :halt, [422, json_response(:errors => record.errors.full_messages)]
end

post("/evoke") do
  @callback = Callback.new(params)
  if @callback.save
    status(201)
    json_response(@callback)
  else
    invalid_record(@callback)
  end
end
