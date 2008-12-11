ENV['APP_ENV'] ||= (ENV['RACK_ENV'] || 'production')

require 'rubygems'
require 'rack'
require 'sinatra'

Sinatra::Application.default_options.update(
  :run => false,
  :env => ENV['APP_ENV'],
  :raise_errors => true,
  :app_file => 'evoke.rb',
  :root => File.dirname(__FILE__)
)

log = File.new("#{File.dirname(__FILE__)}/log/#{ENV['APP_ENV']}.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'evoke'

run Sinatra.application
