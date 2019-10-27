require_relative 'crawlers/base'
require_relative 'crawlers/gallery'

module OmniScrapper
  # A repository module for crawlers.
  # They are not intended to be developed by end-users, as it is requires awareness
  # of too many technical details of implementation.
  # They are supposed justt to choose between existing crawlers.
  module Crawlers
    DEFAULT_CRAWLER = Gallery

    class << self
      def by_name(name)
        crawlers[name] || DEFAULT_CRAWLER
      end

      private

      def crawlers
        {
          gallery: Gallery
        }
      end
    end
  end
end
