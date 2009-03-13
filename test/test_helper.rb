ENV['APP_ENV'] = 'test'

require 'rubygems'

require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require 'test/unit'
require 'sinatra/test'
require File.join(File.dirname(__FILE__), '..', 'evoke')

require 'ostruct'
require 'shoulda'
require 'shoulda/active_record'
require 'mocha'
require File.join(File.dirname(__FILE__), 'model_factory')

require 'chicago/shoulda'
require_local_lib('../test/shoulda')

class Test::Unit::TestCase
  include Sinatra::Test

  alias_method :old_run, :run
  
  def run(*args, &block)
    exception_thrown = false
    ActiveRecord::Base.transaction do
      begin
        old_run(*args, &block)
      rescue => e
        exception_thrown = true
        raise e
      ensure
        raise ActiveRecord::Rollback unless exception_thrown
      end
    end
  end

  def O(*args) OpenStruct.new(*args); end # Shortcut for OpenStruct

end
