require 'omni_scrapper/proxy'

module OmniScrapper
  module Crawlers
    class Base
      class MissingCrawlerConfigurationField < StandardError; end;

      class << self
        def run(&block)
          new.run(&block)
        end

        def required_attributes
          BASE_REQUIRED_ATTRIBUTES + self.crawler_specific_required_attributes
        end
      end

      BASE_REQUIRED_ATTRIBUTES = %i(
        entrypoint
        next_page_link
        page_link
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
        @handler = block
        start_crawler
      end

      def scrape_page(uri)
        # TODO: inject some hook into omniscrapper, to be executed at this moment
        visit(uri)

        data = Page
          .new(uri, current_page_body, configuration)
          .data
          .tap { |result| validate_data!(result) }

        result = OmniScrapper::Result.new(name, uri).build(data)
        @handler.call(result)
        configuration.scrapping_success_handler.call(uri, result)
      rescue => e
        # TODO: notify API about exception
        configuration.scrapping_error_handler.call(uri, e)
      end

      def start_crawler(&block)
        fail NotImplementedError, 'Implement #start_crawler in specific crawler'
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
        self.class.required_attributes.each do |attribute_name|
          raise MissingCrawlerConfigurationField, attribute_name unless configuration.anchors.keys.include?(attribute_name)
        end
      end
    end
  end
end
