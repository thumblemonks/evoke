require File.join(File.dirname(__FILE__), 'test_helper')

class EvokeTest < Test::Unit::TestCase
  context "adding a callback" do
    context "when missing url" do
      setup { post_it "/callbacks", Factory.attributes_for(:callback, :url => "") }
      should_have_response_status 422
      should_have_json_response :errors => ["Url can't be blank"]
    end

    context "when missing call back at" do
      setup { post_it "/callbacks", Factory.attributes_for(:callback, :callback_at => "") }
      should_have_response_status 422
      should_have_json_response :errors => ["Callback at can't be blank"]
    end
    
    context "with valid data" do
      setup do
        @guid = Factory.next(:guid)
        post_it "/callbacks", Factory.attributes_for(:callback, :guid => @guid)
      end
      should_have_response_status 201
      should_have_json_response { Callback.first }
      should_change "Callback.count", :by => 1
      should_change 'Delayed::Job.count', :by => 1

      should "tie the callback to a new job" do
        assert_not_nil Callback.by_guid(@guid).delayed_job
      end
    end
  end

  context "updating a callback" do
    setup do
      @callback = Factory(:callback_with_job, :guid => 'lulu-rouge')
    end

    context "without a guid" do
      setup { put_it "/callbacks/" }
      should_have_response_status 404
    end

    context "without an existing guid" do
      setup { put_it "/callbacks/mustard-pimp" }
      should_have_response_status 404
      should_have_json_response ""
    end

    context "when no data provided" do
      setup do
        put_it "/callbacks/#{@callback.guid}"
        @callback.reload
      end
      should_have_response_status 201
      should_have_json_response { @callback }
      should_change "Callback.count", :by => 0
    end

    context "when only url provided" do
      setup do
        put_it "/callbacks/#{@callback.guid}", :url => "http://bar.baz"
        @callback.reload
      end
      should_have_response_status 201
      should_have_json_response %r[\"url\":\"http:\\/\\/bar\.baz\"]
      should_change "Callback.count", :by => 0
    end

    context "when only callback at provided" do
      setup do
        @callback_at = (Time.now - 86400)
        put_it "/callbacks/#{@callback.guid}", :callback_at => @callback_at
        @callback.reload
      end
      should_have_response_status 201
      should_have_json_response do
        time = @callback_at.strftime("%Y/%m/%d %H:%M:%S %z")
        %r[\"callback_at\":\"#{time}\"]
      end
      should_change "Callback.count", :by => 0
    end

    context "when bad data provided" do
      setup { put_it "/callbacks/#{@callback.guid}", :url => "" }
      should_have_response_status 422
      should_have_json_response :errors => ["Url can't be blank"]
    end

    context "when updating delayed job" do
      setup do
        @old_job = @callback.delayed_job
        put_it "/callbacks/#{@callback.guid}", :url => "http://bar.baz"
        @callback.reload
      end
      should_change 'Delayed::Job.count', :by => 0

      should "remove the old delayed job" do
        assert_not_nil @old_job
        assert_nil Delayed::Job.find_by_id(@old_job.id)
      end

      should "reference a new delayed job" do
        assert_not_equal @old_job, @callback.delayed_job
        assert_not_nil @callback.delayed_job
      end
    end
  end

  context "retrieving a callback" do
    context "without a guid" do
      setup { get_it '/callbacks' }
      should_have_response_status 404
    end

    context "without an existing guid" do
      setup { get_it '/callbacks/franken-furter' }
      should_have_response_status 404
    end

    context "with a guid" do
      setup do
        @callback = Factory(:callback, :guid => 'kids-with-guns')
        get_it '/callbacks/kids-with-guns'
      end
      should_have_response_status 201
      should_have_json_response { @callback }
    end
  end

end
