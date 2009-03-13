ENV['APP_ENV'] ||= (ENV['RACK_ENV'] || 'production')

require 'rubygems'
require 'rack'
require 'sinatra'

set :environment, ENV['APP_ENV']
set :root, File.dirname(__FILE__)
set :raise_errors, true
disable :run

log = File.new("#{File.dirname(__FILE__)}/log/#{ENV['APP_ENV']}.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'evoke'

map "/" do
  run Sinatra::Application
end
