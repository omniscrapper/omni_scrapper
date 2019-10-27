require 'omni_scrapper/proxy'

module OmniScrapper
  module Crawlers
    class Base
      class MissingCrawlerConfigurationField < StandardError; end;

      class << self
        def run(&block)
          new.run(&block)
        end
      end

      def initialize(entrypoint_url = nil)
        validate_crawler_configuration!

        self.entrypoint = entrypoint_url || entrypoint_pattern
        self.agent = Mechanize.new do |a|
          a.user_agent_alias = 'Mac Safari'
        end
        self.agent.set_proxy(Proxy.host, Proxy.port) if Proxy.enabled?
      end

      private

      def scrap_page(page)
        puts "[Crawler] Scrapping #{page.uri.to_s}"
        data = Page.new(page, configuration).data
        OmniScrapper::Result.new(name).tap { |result| result.build(data) }
      end

      def validate_crawler_configuration!
        self.class::REQUIRED_ATTRIBUTES.each do |attribute_name|
          raise MissingCrawlerConfigurationField, attribute_name unless configuration.anchors.keys.include?(attribute_name)
        end
      end
    end
  end
end
