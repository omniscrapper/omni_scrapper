require_relative 'drivers/mechanize'

module OmniScrapper
  module Crawlers
    # The most trivial crawler for gallery-like websites.
    # It recursively walks through paginated lists and visit each link matching with
    # defined patten on this page. Then it get's back and proceeds crawling.
    class Gallery < Base
      include Drivers::Mechanize

      # TODO: replace with this macros
      #required_attributes :id_within_site
      def self.crawler_specific_required_attributes
        %i(id_within_site)
      end

      def start_crawler
        self.current_page = agent.get(entrypoint)
        puts "[Crawler] visited: #{entrypoint}, next_page_url: #{next_page_url} pattern: #{next_page_link_pattern}"

        pages_to_collect.each do |page_link|
          sleep(1)
          page = agent.click(page_link)
          data = scrape_page(page.uri.to_s, page.body)
          yield(data)
        end

        self.class.new(next_page_url).run(&block) if next_page_url
      end

      private

      def next_page_url
        current_page.link_with(text: next_page_link_pattern)&.resolved_uri
      end

      def pages_to_collect
        current_page
          .links_with(href: page_link_pattern)
          .reject { |l| l.text.strip == '' }
          .uniq { |l| l.href }
      end
    end
  end
end
