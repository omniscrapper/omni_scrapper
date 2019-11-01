require_relative 'drivers/mechanize'
require_relative 'drivers/ferrum'

module OmniScrapper
  module Crawlers
    # The most trivial crawler for gallery-like websites.
    # It recursively walks through paginated lists and visit each link matching with
    # defined patten on this page. Then it get's back and proceeds crawling.
    class Gallery < Base
      #include Drivers::Mechanize
      include Drivers::Ferrum

      # TODO: replace with this macros
      #required_attributes :id_within_site
      def self.crawler_specific_required_attributes
        %i(id_within_site)
      end

      def start_crawler(&block)
        visit(entrypoint)
        puts "[Crawler] visited: #{entrypoint}"

        gallery_pages.each do |page_link|
          # TODO: configure delay in crawler params
          sleep(1)
          data = scrape_page(page_link)
          block.call(data)
        end
        self.class.new(next_page_url).run(&block) if next_page_url
      end

      private

      def next_page_url
        current_page
          .links
          .find { |l| l.text.strip == next_page_link_pattern }&.resolved_uri
      end

      def gallery_pages
          urls_with_pattern(next_page_link_pattern)
          .reject { |l| l.text.strip == '' }
          .map { |l| l.resolved_uri }
          .uniq
      end
    end
  end
end
