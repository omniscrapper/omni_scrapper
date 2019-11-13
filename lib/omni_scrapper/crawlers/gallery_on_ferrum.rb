require_relative 'drivers/ferrum'
require_relative 'gallery'

module OmniScrapper
  module Crawlers
    # Ferrum version of gallery scrapper
    class GalleryOmFerrum < Gallery
      include Drivers::Ferrum
    end
  end
end
