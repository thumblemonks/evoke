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
end
