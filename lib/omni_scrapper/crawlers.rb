require_relative 'crawlers/base'
require_relative 'crawlers/gallery'
require_relative 'crawlers/gallery_on_ferrum'

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

      def all_names
        crawlers.keys
      end

      private

      def crawlers
        {
          gallery: Gallery,
          gallery_on_ferrum: GalleryOmFerrum
        }
      end
    end
  end
end
