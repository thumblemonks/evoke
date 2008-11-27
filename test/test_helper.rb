require 'rubygems'
require 'hpricot'

require 'sinatra'
require 'sinatra/test/unit'
require File.join(File.dirname(__FILE__), '..', 'evoke')

require 'ostruct'
require 'shoulda'
require 'shoulda/active_record'
require 'mocha'
require File.join(File.dirname(__FILE__), 'model_factory')

require_local_lib('../test/shoulda/*.rb')

class Test::Unit::TestCase
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

    # Generic test helpers

  def deny(check, message=nil) assert(!check, message); end

end
