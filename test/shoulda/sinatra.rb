require 'json'

# TODO: Extract all of this into a gem called thumblemonks-shoulda_sinatra or something
module Thumblemonks
  module Sinatra
    module Shoulda

      def self.included(klass)
        klass.extend(Macros)
        klass.send(:include, Helpers)
      end

      module Macros
        def should_have_response_status(expected)
          should("have response status") { assert_response expected }
        end
      
        def should_have_response_body(expected)
          should("have response body") { assert_response_body expected }
        end

        def should_have_content_type(expected)
          should("have content_type") { assert_content_type expected }
        end

        def should_have_json_response(json={}, &block)
          should_have_content_type 'application/json'
          should "have JSON response in the body" do
            json = self.instance_eval(&block) if block_given?
            assert_response_body json.to_json
          end
        end

      end # Macros

      module Helpers
        def deny(check, message=nil)
          assert(!check, message)
        end

        def assert_response(status)
          assert_equal status, @response.status
        end

        def assert_response_body(body)
          assert_equal body, @response.body
        end

        def assert_content_type(expected)
          assert_equal expected, @response.headers['Content-type']
        end

        # assert_redirected_to '/foo/bar'
        #   or
        # assert_redirected_to %r[foo.bar]
        def assert_redirected_to(expected_path)
          yield if block_given?
          assert_response 302
          action = expected_path.kind_of?(Regexp) ? 'match' : 'equal'
          send("assert_#{action}", expected_path, @response.headers["Location"])
        end
      end # Helpers

    end # Shoulda
  end # Sinatra
end # Thumblemonks

Test::Unit::TestCase.send(:include, Thumblemonks::Sinatra::Shoulda)
