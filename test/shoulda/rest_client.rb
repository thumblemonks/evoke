module Thumblemonks
  module RestClient
    module Shoulda

      def restful_methods(except=nil)
        [:get, :post, :put, :delete].reject { |m| m == except }
      end

      def expect_restful_request(method, *args)
        stub_restful_requests( restful_methods(method.to_sym) )
        ::RestClient.expects(method).with(*args)
      end

      def expect_restful_request_failure(method, *raises)
        stub_restful_requests( restful_methods(method.to_sym) )
        ::RestClient.expects(method).raises(*raises)
      end

      def stub_restful_requests(methods=nil)
        (methods || restful_methods).each { |method| ::RestClient.stubs(method) }
      end

    end # Shoulda
  end # RestClient
end # Thumblemonks

Test::Unit::TestCase.send(:include, Thumblemonks::RestClient::Shoulda)
