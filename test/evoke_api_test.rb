require File.join(File.dirname(__FILE__), 'test_helper')

class EvokeApiTest < Test::Unit::TestCase
  def app
    @app = Evoke::Api
  end

  context "adding a callback" do
    context "when missing url" do
      setup { post "/callbacks", Factory.attributes_for(:callback, :url => "") }
      should_have_response_status 422
      should_have_json_response :errors => ["Url can't be blank"]
    end

    context "when missing call back at" do
      setup { post "/callbacks", Factory.attributes_for(:callback, :callback_at => "") }
      should_have_response_status 422
      should_have_json_response :errors => ["Callback at can't be blank"]
    end
    
    context "with valid data" do
      setup do
        @guid = Factory.next(:guid)
        CallbackRunner.expects(:make_job_from_callback!).with(anything)
        post "/callbacks", Factory.attributes_for(:callback, :guid => @guid)
      end
      should_have_response_status 201
      should_have_json_response { Callback.first }
      should_change "Callback.count", :by => 1
    end
  end

  context "updating a callback" do
    setup do
      @callback = Factory(:callback_with_job, :guid => 'lulu-rouge')
    end

    context "without a guid" do
      setup { put "/callbacks/" }
      should_have_response_status 404
    end

    context "without an existing guid" do
      setup { put "/callbacks/mustard-pimp" }
      should_have_response_status 404
      should_have_json_response ""
    end

    context "when no data provided" do
      setup do
        put "/callbacks/#{@callback.guid}"
        @callback.reload
      end
      should_have_response_status 200
      should_have_json_response { @callback }
      should_change "Callback.count", :by => 0
    end

    context "when only url provided" do
      setup do
        put "/callbacks/#{@callback.guid}", :url => "http://bar.baz"
        @callback.reload
      end
      should_have_response_status 200
      should_have_json_response %r[\"url\":\"http:\\/\\/bar\.baz\"]
      should_change "Callback.count", :by => 0
    end

    context "when only callback at provided" do
      setup do
        @callback_at = (Time.now - 86400)
        put "/callbacks/#{@callback.guid}", :callback_at => @callback_at
        @callback.reload
      end
      should_have_response_status 200
      should_have_json_response do
        time = @callback_at.strftime("%Y/%m/%d %H:%M:%S %z")
        %r[\"callback_at\":\"#{time}\"]
      end
      should_change "Callback.count", :by => 0
    end

    context "when bad data provided" do
      setup { put "/callbacks/#{@callback.guid}", :url => "" }
      should_have_response_status 422
      should_have_json_response :errors => ["Url can't be blank"]
    end

    context "when updating job" do
      setup do
        CallbackRunner.expects(:replace_job_for_callback!).with(@callback)
      end
      
      should "replace job for same callback" do
        put "/callbacks/#{@callback.guid}", :url => "http://bar.baz"
      end
    end
  end

  context "retrieving a callback" do
    context "without a guid" do
      setup { get '/callbacks' }
      should_have_response_status 404
    end

    context "without an existing guid" do
      setup { get '/callbacks/franken-furter' }
      should_have_response_status 404
    end

    context "without a blank guid" do
      setup do
        Factory(:callback)
        get '/callbacks/'
      end
      should_have_response_status 404
    end

    context "with a guid" do
      setup do
        @callback = Factory(:callback, :guid => 'kids-with-guns')
        get '/callbacks/kids-with-guns'
      end
      should_have_response_status 200
      should_have_json_response { @callback }
    end
  end # retrieving a callback

  context "deleting a callback" do
    context "without a guid" do
      setup { delete '/callbacks' }
      should_have_response_status 404
    end

    context "without an existing guid" do
      setup { delete '/callbacks/franken-furter' }
      should_have_response_status 404
    end

    context "with a valid guid" do
      setup do
        @callback = Factory(:callback, :guid => 'kids-with-guns')
        Callback.any_instance.expects(:destroy)
        delete '/callbacks/kids-with-guns'
      end
      should_have_response_status 200
      should_have_json_response(/^$/)
    end
  end # deleting a callback

end
