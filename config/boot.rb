ENV['APP_ENV'] ||= 'development'
def require_local_lib(path)
  Dir["#{File.dirname(__FILE__)}/#{path}/*.rb"].each {|f| require f }
end

%w[rubygems logger config/database rest_client delayed_job sinatra chicago].each do |lib|
  require lib
end

Sinatra::Base.set :environment => ENV['APP_ENV'].to_sym,
  :raise_errors => true,
  :dump_errors => true,
  :app_file => 'evoke.rb'

require_local_lib('../models')
