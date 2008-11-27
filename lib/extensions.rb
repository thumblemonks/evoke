# TODO: Extract all of this into a gem called thumblemonks-sinatra_extensions or something
# Might/Should include database stuff
module Thumblemonks
  module Sinatra
    module Extensions
      # Returns a JSON response for an object
      def json_response(object)
        content_type 'application/json'
        object.to_json
      end

      # Assumes all CSS is SASS and is referenced as being in a directory named
      # stylesheets
      def catch_all_css
        get('/stylesheets/*.css') {sass params["splat"].first.to_sym}
      end

      # When you don't want to do anything special, but load a named resource
      def get_obvious(name)
        get "/#{name}" do
          title = name.to_s
          haml name.to_sym
        end
      end
    end # Extensions
  end # Sinatra
end # Thumblemonks
