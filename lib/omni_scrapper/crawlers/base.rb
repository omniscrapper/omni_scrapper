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

      BASE_REQUIRED_ATTRIBUTES = %i(
        entrypoint
        next_page_link
        page_link
        id_within_site
      )

      attr_accessor :current_page, :entrypoint

      def initialize(entrypoint_url = nil)
        validate_crawler_configuration!
        prepare_driver

        self.entrypoint = entrypoint_url || entrypoint_pattern
        set_user_agent('Mac Safari')
        # TODO: also allow to configure proxy settings via some external config.
        set_proxy(Proxy.host, Proxy.port) if Proxy.enabled?
      end

      def run(&block)
        self.current_page = agent.get(entrypoint)
        puts "[Crawler] visited: #{entrypoint}"
        collect(pages_to_collect, &block)
        self.class.new(next_page_url).run(&block) if next_page_url
      end

      def scrape_page(page)
        puts "[Crawler] Scrapping #{page.uri.to_s}"
        # TODO: inject some hook into omniscrapper, to be executed at this moment

        data = Page
          .new(page.uri, page.body, configuration)
          .data
          .tap { |result| validate_data!(result) }

        OmniScrapper::Result.new(name).tap { |result| result.build(data) }
      end

      private

      def validate_data!(result_data)
        # TODO: Fix this is not working
        # schema_pattern method is not available here
        # uncomment when move this to scrapper level
        result_data.tap do |data|
          schema.validate!(result_data)
        end
      end

      def schema
        Schema.new(configuration.schema)
      end

      def validate_crawler_configuration!
        self.class::REQUIRED_ATTRIBUTES.each do |attribute_name|
          raise MissingCrawlerConfigurationField, attribute_name unless configuration.anchors.keys.include?(attribute_name)
        end
      end
    end
  end
end
