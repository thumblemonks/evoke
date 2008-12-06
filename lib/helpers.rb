module Thumblemonks
  module Sinatra
    module Helpers
      def anchor(name, url, options={})
        defaults = {:href => url}
        options_str = hash_to_attributes(defaults.merge(options))
        %Q[<a #{options_str}>#{name}</a>]
      end

      def stylesheet_include(name, options={})
        defaults = {:href => "/stylesheets/#{name}.css", :media => "screen",
          :rel => "stylesheet", :type => "text/css"}
        options_str = hash_to_attributes(defaults.merge(options))
        %Q[<link #{options_str}/>]
      end
    private
      def hash_to_attributes(options)
        options.map {|k,v| "#{k}=\"#{v}\""}.join(' ')
      end
    end # Helpers
  end # Sinatra
end # Thumblemonks

# Sinatra::EventContext.instance_eval { include Thumblemonks::Sinatra::Helpers }
