ENV['APP_ENV'] = 'test'

require 'rubygems'

require 'test/unit'
require 'rack/test'
require File.join(File.dirname(__FILE__), '..', 'evoke')

require 'ostruct'
require 'shoulda'
require 'shoulda/active_record'
require 'mocha'
require File.join(File.dirname(__FILE__), 'model_factory')

require 'chicago/shoulda'
require_local_lib('../test/shoulda')

class Test::Unit::TestCase
  include Rack::Test::Methods

  alias_method :old_run, :run
  def run(*args, &block)
    exception_thrown = false
    ActiveRecord::Base.transaction do
      exception_thrown = false
      begin
        old_run(*args, &block)
      rescue Exception => e
        exception_thrown = true
        raise e
      ensure
        raise ActiveRecord::Rollback unless exception_thrown
      end
    end
  end
end
