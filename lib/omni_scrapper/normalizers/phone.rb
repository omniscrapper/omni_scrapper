require_relative 'base'
require_relative '../exceptions/no_phone_on_page_exception'

module OmniScrapper
  module Normalizers
    class Phone < Base
      def normalized
        result = value.scan(/([0-9 \-\(\)]{10,})/).flatten.last&.gsub(/[ \-\(\)]/, '')
        raise OmniScrapper::NoPhoneOnPageException.new(value) unless result
        result
      end
    end
  end
end
