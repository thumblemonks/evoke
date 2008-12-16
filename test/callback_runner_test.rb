require File.join(File.dirname(__FILE__), 'test_helper')

class CallbackRunnerTest < Test::Unit::TestCase
  def callback_with_runner(attributes={})
    callback = Factory(:callback, attributes)
    runner = CallbackRunner.new(callback)
    [callback, runner]
  end

  should "barf if nil callback given to initializer" do
    assert_raise(ArgumentError) { CallbackRunner.new(nil) }
  end

  context "making job from callback" do
    setup do
      @callback = Factory(:callback)
    end

    should "enqueue a new delayed job" do
      runner = stub('runner')
      CallbackRunner.expects(:new).with(@callback).returns(runner)
      Delayed::Job.expects(:enqueue).with(runner, 0, @callback.callback_at)
      CallbackRunner.make_job_from_callback!(@callback)
    end

    should "update callback with the new job" do
      job = stub('job')
      Delayed::Job.expects(:enqueue).returns(job)
      @callback.expects(:update_attributes!).with({:delayed_job => job})
      CallbackRunner.make_job_from_callback!(@callback)
    end
  end

  context "replacing job for callback" do
    setup do
      @callback = Factory(:callback)
    end

    context "when callback has a job" do
      setup do
        @job = stub('job')
        @job.expects(:destroy)
        @callback.stubs(:delayed_job).returns(@job)
      end

      should "delete old job tied to callback" do
        CallbackRunner.replace_job_for_callback!(@callback)
      end
    end

    should "not delete any jobs when callback has no job" do
      Delayed::Job.any_instance.expects(:destroy).never
      CallbackRunner.replace_job_for_callback!(@callback)
    end

    should "always update callback with a new job" do
      @runner = stub('runner')
      CallbackRunner.expects(:new).with(@callback).returns(@runner)
      job = stub('job')
      Delayed::Job.expects(:enqueue).with(@runner, 0, @callback.callback_at).returns(job)
      @callback.expects(:update_attributes!).with({:delayed_job => job})
      CallbackRunner.replace_job_for_callback!(@callback)
    end
  end

  context "inducing perform" do

    should "reload callback from database before running anything" do
      stub_restful_requests
      @callback, @runner = callback_with_runner
      @callback.expects(:reload)
      @runner.perform
    end

    context "with url but no method" do
      setup { @callback, @runner = callback_with_runner(:data => nil) }
      
      should "send a get request with no payload" do
        expect_restful_request(:get, @callback.url)
        @runner.perform
      end
  
      should "note that the url was called back" do
        stub_restful_requests
        @runner.perform
        assert @callback.called_back?
      end
    end # with url but no method
  
    context "with get" do
      context "and no data" do
        setup do
          @callback, @runner = callback_with_runner(:method => 'get', :data => nil)
        end
  
        should "still not provide a payload" do
          expect_restful_request(:get, @callback.url)
          @runner.perform
        end
      end
  
      context "and data" do
        setup do
          @callback, @runner = callback_with_runner(:method => 'get', :data => 'abc')
        end
  
        should "still not inlcude a payload" do
          expect_restful_request(:get, @callback.url)
          @runner.perform
        end
      end
    end # with get
  
    context "with put" do
      context "and no data" do
        setup do
          @callback, @runner = callback_with_runner(:method => 'put', :data => nil)
        end
  
        should "still pass a payload of empty string" do
          expect_restful_request(:put, @callback.url, '')
          @runner.perform
        end
      end
  
      context "and data" do
        setup do
          @callback, @runner = callback_with_runner(:method => 'put', :data => 'abc')
        end
  
        should "include the data as the payload" do
          expect_restful_request(:put, @callback.url, 'abc')
          @runner.perform
        end
      end
    end # with put
  
    context "with post" do
      context "and no data" do
        setup do
          @callback, @runner = callback_with_runner(:method => 'post', :data => nil)
        end
  
        should "still pass a payload of empty string" do
          expect_restful_request(:post, @callback.url, '')
          @runner.perform
        end
      end
  
      context "and data" do
        setup do
          @callback, @runner = callback_with_runner(:method => 'post', :data => 'abc')
        end
  
        should "include the data as the payload" do
          expect_restful_request(:post, @callback.url, 'abc')
          @runner.perform
        end
      end
    end # with post
  
    context "with delete" do
      context "and no data" do
        setup do
          @callback, @runner = callback_with_runner(:method => 'delete', :data => nil)
        end
  
        should "still not provide a payload" do
          expect_restful_request(:delete, @callback.url)
          @runner.perform
        end
      end
  
      context "and data" do
        setup do
          @callback, @runner = callback_with_runner(:method => 'delete', :data => 'abc')
        end
  
        should "still not inlcude a payload" do
          expect_restful_request(:delete, @callback.url)
          @runner.perform
        end
      end
    end # with delete
  
    context "which then fails" do
      setup do
        @callback, @runner = callback_with_runner
        expect_restful_request_failure(:get, ::RestClient::ResourceNotFound)
        @runner.perform
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
