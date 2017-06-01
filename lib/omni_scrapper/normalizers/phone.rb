require_relative 'base'

module OmniScrapper
  module Normalizers
    class Phone < Base
      def normalized
        value.scan(/([0-9 \-\(\)]{10,})/).flatten.last.gsub(/[ \-\(\)]/, '')
      end
    end
  end
end
