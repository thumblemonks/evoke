require 'rubygems'

def require_local_lib(pattern)
  Dir.glob(File.join(File.dirname(__FILE__), pattern)).each {|f| require f }
end
require_local_lib('../lib/*.rb')
require_local_lib('../models/*.rb')
require 'logger'
require 'delayed_job'
require 'rest_client'
