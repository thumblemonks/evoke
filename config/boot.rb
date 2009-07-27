ENV['APP_ENV'] ||= 'development'
def require_local_lib(path)
  Dir["#{File.dirname(__FILE__)}/#{path}/*.rb"].each {|f| require f }
end

require 'yaml'
Configuration = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))

LIBS = %w[rubygems logger config/database rest_client delayed_job haml sass
  sinatra chicago sinatra/authorization]
LIBS.each { |lib| require lib }
require_local_lib('../models')

Sinatra::Base.set :environment => ENV['APP_ENV'].to_sym,
  # :root => File.join(File.dirname(__FILE__), '..'),
  :raise_errors => true,
  :dump_errors => true,
  :static => true,
  :app_file => File.join(File.dirname(__FILE__), '..', 'evoke.rb'),
  :authorization_realm => "Evoke Internals"
