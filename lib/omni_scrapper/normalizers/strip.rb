require_relative 'base'

module OmniScrapper
  module Normalizers
    # TODO: make macros `description` which persists class description in field
    # to allow web app to extract all normalizers descriptions and display
    # them as hints in UI
    # Removes extra whitespaces and 
    class Strip < Base
      def call
        value.gsub(/\s+/, ' ').gsub(/^[^[:word:]]/, '').gsub("\n", '').strip
      end
    end
  end
end
