require File.join(File.dirname(__FILE__), 'test_helper')

class CallbackTest < Test::Unit::TestCase
  should_require_attributes :url, :callback_at
  should_have_db_column :data
  should_have_db_column :called_back
  should_have_db_column :method
  should_have_db_column :error_message
  should_belong_to :delayed_job
  should_allow_values_for :guid, nil

  context "called back!" do
    setup do
      @callback = Factory(:callback)
      @callback.called_back!
    end
    should("return true for called back?") { assert @callback.called_back? }
  end

  context "before save" do
    setup do
      @callback = Factory(:callback, :data => nil, :guid => '  ')
    end
    
    should "set nil data to empty string" do
      assert_equal '', @callback.data
    end

    should "turn blank guid into nil" do
      assert_nil @callback.guid
    end
  end

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

  context "inducing perform" do
    context "with url but no method" do
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
    end # with url but no method

    context "with get" do
      context "and no data" do
        setup { @callback = Factory(:callback, :method => 'get', :data => nil) }

        should "still not provide a payload" do
          expect_restful_request(:get, @callback.url)
          @callback.perform
        end
      end

      context "and data" do
        setup { @callback = Factory(:callback, :method => 'get', :data => 'abc') }

        should "still not inlcude a payload" do
          expect_restful_request(:get, @callback.url)
          @callback.perform
        end
      end
    end # with get

    context "with put" do
      context "and no data" do
        setup { @callback = Factory(:callback, :method => 'put', :data => nil) }

        should "still pass a payload of empty string" do
          expect_restful_request(:put, @callback.url, '')
          @callback.perform
        end
      end

      context "and data" do
        setup { @callback = Factory(:callback, :method => 'put', :data => 'abc') }

        should "include the data as the payload" do
          expect_restful_request(:put, @callback.url, 'abc')
          @callback.perform
        end
      end
    end # with put

    context "with post" do
      context "and no data" do
        setup { @callback = Factory(:callback, :method => 'post', :data => nil) }

        should "still pass a payload of empty string" do
          expect_restful_request(:post, @callback.url, '')
          @callback.perform
        end
      end

      context "and data" do
        setup { @callback = Factory(:callback, :method => 'post', :data => 'abc') }

        should "include the data as the payload" do
          expect_restful_request(:post, @callback.url, 'abc')
          @callback.perform
        end
      end
    end # with post

    context "with delete" do
      context "and no data" do
        setup { @callback = Factory(:callback, :method => 'delete', :data => nil) }

        should "still not provide a payload" do
          expect_restful_request(:delete, @callback.url)
          @callback.perform
        end
      end

      context "and data" do
        setup { @callback = Factory(:callback, :method => 'delete', :data => 'abc') }

        should "still not inlcude a payload" do
          expect_restful_request(:delete, @callback.url)
          @callback.perform
        end
      end
    end # with delete

    context "which then fails" do
      setup do
        @callback = Factory(:callback)
        expect_restful_request_failure(:get, ::RestClient::ResourceNotFound)
        @callback.perform
      end

      should "note that the url was not called back" do
        deny @callback.called_back?
      end

      should "record error message in callback" do
        assert_equal "Resource not found", @callback.error_message
      end
    end # which then fails
  end # inducing perform

end
