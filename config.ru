ENV['APP_ENV'] ||= (ENV['RACK_ENV'] || 'production')

require 'rubygems'
require 'evoke'

use Rack::CommonLogger, File.new("#{File.dirname(__FILE__)}/log/#{ENV['APP_ENV']}.log", 'a+')

use Evoke::Api
use Evoke::Status
run Sinatra::Base
