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

      def start_crawler
        visit(entrypoint)
        next_page = link_url(next_page_link_pattern)
        puts "[Crawler] visited: #{entrypoint}"

        gallery_pages.each do |page_link|
          # TODO: configure delay in crawler params
          sleep(1)
          scrape_page(page_link)
        end

        return unless next_page_exists?(next_page)

        self.entrypoint = next_page
        start_crawler
      end

      private

      def next_page_exists?(next_page)
        next_page && root_url != next_page
      end

      def url_to(path)
        path_uri = URI(path)
        return path unless path_uri.host == nil
        URI("#{root_url}#{path}").to_s
      rescue URI::InvalidURIError
        ''
      end

      def root_url
        "#{current_uri.scheme}://#{current_uri.host}"
      end

      def gallery_pages
        urls_with_pattern(page_link_pattern)
          .reject { |l| l == '' }
          .uniq
      end
    end
  end
end
