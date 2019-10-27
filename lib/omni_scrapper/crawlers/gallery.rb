module OmniScrapper
  module Crawlers
    # The most trivial crawler for gallery-like websites.
    # It recursively walks through paginated lists and visit each link matching with
    # defined patten on this page. Then it get's back and proceeds crawling.
    class Gallery < Base
      attr_accessor :agent, :current_page, :entrypoint

      REQUIRED_ATTRIBUTES = %i(
        entrypoint
        next_page_link
        page_link
        id_within_site
      )

      def run(&block)
        agent.get(entrypoint) do |page|
          self.current_page = page
        end
        agent.keep_alive = false
        collect(pages_to_collect, &block)
        puts "[Crawler] visited: #{entrypoint}"

        self.class.new(next_page_url).run(&block) if next_page_url
      end

      private

      def next_page_url
        current_page.link_with(text: next_page_link_pattern)&.resolved_uri
      end

      def collect(page_links)
        page_links.each do |page_link|
          sleep(1)
          page = agent.click(page_link)
          data = scrap_page(page)
          yield(data)
        end
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
