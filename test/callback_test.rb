require File.join(File.dirname(__FILE__), 'test_helper')

class CallbackTest < Test::Unit::TestCase
  should_require_attributes :url, :callback_at
  should_have_db_column :data
  should_have_db_column :called_back
  should_have_db_column :method
  should_have_db_column :error_message
  should_allow_values_for :guid, nil

  context "called back!" do
    setup do
      @callback = Factory(:callback)
      @callback.called_back!
    end
    should("return true for called back?") { assert @callback.called_back? }
  end

  context "after create" do
    setup do
      @callback = Factory(:callback)
    end
    
    should_change 'Delayed::Job.count', :by => 1
  end

  should "turn blank guid into nil"

  context "by guid" do
    setup do
      @callback = Factory(:callback, :guid => 'luscious-jackson')
    end

    should_require_unique_attributes :guid

    should "return a single callback if guid is exists" do
      assert_equal @callback, Callback.by_guid('luscious-jackson')
    end

    should "return nil if guid does not exist" do
      assert_nil Callback.by_guid('with-my-naked-eye-i-saw')
    end
  end

  context "perform" do
    context "with url but no method or data" do
      setup do
        @callback = Factory(:callback, :data => nil)
      end
      
      should "send a get request with no payload" do
        expect_restful_request(:get, @callback.url)
        @callback.perform
      end

      should "note that the url was called back" do
        stub_restful_requests
        @callback.perform
        assert @callback.called_back?
      end
    end

    context "with url and data but no method" do
      setup do
        @callback = Factory(:callback, :data => 'foo=bar&baz=goo')
      end
      
      should "send data as payload of get request" do
        expect_restful_request(:get, @callback.url, @callback.data)
        @callback.perform
      end

      should "note that the url was called back" do
        stub_restful_requests
        @callback.perform
        assert @callback.called_back?
      end
    end

    context "with url and method but no data" do
      setup { @callback = Factory(:callback, :method => 'put', :data => nil) }
      should "use method provided by client in request" do
        expect_restful_request(:put, @callback.url)
        @callback.perform
      end

      should "note that the url was called back" do
        stub_restful_requests
        @callback.perform
        assert @callback.called_back?
      end
    end

    context "which then fails" do
      setup do
        @callback = Factory(:callback)
        expect_restful_request_failure(:get, ::RestClient::ResourceNotFound)
        @callback.perform
      end

      should "not note the url as being called back" do
        deny @callback.called_back?
      end

      should "record error message in callback" do
        assert_equal "Resource not found", @callback.error_message
      end
    end
  end

end
