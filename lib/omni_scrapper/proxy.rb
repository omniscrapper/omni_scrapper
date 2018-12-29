module OmniScrapper
  class Proxy
    class << self
      def host
        proxy_tokens.first
      end

      def port
        proxy_tokens.last
      end

      def enabled?
        ENV.key? 'http_proxy'
      end

      private

      def proxy_tokens
        ENV['http_proxy'].gsub('http://', '').split(':')
      end
    end
  end
end
