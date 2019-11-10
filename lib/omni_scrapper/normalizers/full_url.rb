require_relative 'base'

module OmniScrapper
  module Normalizers
    # Adds missing protocol and host definition to url
    class FullUrl < Base
      def call
        return value if current_uri.host
        "#{root_uri.scheme}://#{root_uri.host}#{value}"
      end

      private

      def current_uri
        URI(value)
      end

      def root_uri
        URI(options[:url])
      end
    end
  end
end
