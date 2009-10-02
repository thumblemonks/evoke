require File.join(File.dirname(__FILE__), 'test_helper')

class EvokeStatusTest < Test::Unit::TestCase
  def app
    @app = Evoke::Status
  end

  context "displaying status" do
    context "when logged in" do
      setup do
        10.times { |n| Factory(:callback, :guid => "aphex-analord-#{n}") }
        credentials = ["foo:bar"].pack("m*")
        get '/status', {}, { "HTTP_AUTHORIZATION" => "Basic #{credentials}" }
      end

      should_have_response_body(/(li class='callback')/)
      should_have_response_status 200
    end

    context "when not logged in" do
      setup { get '/status' }

      should_have_response_status 401
    end
  end # displaying status

end
