ENV['APP_ENV'] ||= 'development'
def require_local_lib(path)
  Dir["#{File.dirname(__FILE__)}/#{path}/*.rb"].each {|f| require f }
end

%w[rubygems logger config/database].each(&method(:require))
require 'rest_client'
require 'delayed_job'
require 'sinatra'
require 'chicago'

set :run, false

require_local_lib('../lib')
require_local_lib('../models')
