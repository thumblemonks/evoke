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
      setup { post_it "/callbacks", Factory.attributes_for(:callback) }
      should_have_response_status 201
      should_have_json_response { Callback.first }
      should_change "Callback.count", :by => 1
    end
  end

  context "updating a callback" do
    setup do
      @callback = Factory(:callback, :guid => 'lulu-rouge')
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
      setup { put_it "/callbacks/#{@callback.guid}" }
      should_have_response_status 201
      should_have_json_response { @callback }
      should_change "Callback.count", :by => 0
    end

    context "when only url provided" do
      setup { put_it "/callbacks/#{@callback.guid}", :url => "http://bar.baz" }
      should_have_response_status 201
      should_have_json_response %r[\"url\":\"http:\\/\\/bar\.baz\"]
      should_change "Callback.count", :by => 0
    end

    context "when only callback at provided" do
      setup do
        @callback_at = (Time.now - 86400)
        put_it "/callbacks/#{@callback.guid}", :callback_at => @callback_at
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
  end

end