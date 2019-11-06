require_relative 'drivers/mechanize'
require_relative 'drivers/ferrum'

module OmniScrapper
  module Crawlers
    # The most trivial crawler for gallery-like websites.
    # It recursively walks through paginated lists and visit each link matching with
    # defined patten on this page. Then it get's back and proceeds crawling.
    class Gallery < Base
      include Drivers::Mechanize
      #include Drivers::Ferrum

      # TODO: replace with this macros
      #required_attributes :id_within_site
      def self.crawler_specific_required_attributes
        %i(id_within_site)
      end

      def start_crawler(&block)
        visit(entrypoint)
        next_page = next_page_url
        puts "[Crawler] visited: #{entrypoint}"

        gallery_pages.each do |page_link|
          # TODO: configure delay in crawler params
          sleep(1)
          data = scrape_page(page_link)
          block.call(data)
        end
        self.class.new(next_page).run(&block) if next_page_url
      end

      private

      def url_to(path)
        path_uri = URI(path)
        return path unless path_uri.host == nil
        result = URI("#{current_uri.scheme}://#{current_uri.host}#{path}")
        result.to_s
      rescue URI::InvalidURIError
        ''
      end

      def gallery_pages
        urls_with_pattern(page_link_pattern)
          .reject { |l| l == '' }
          .uniq
      end
    end
  end
end
