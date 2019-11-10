require_relative 'base'

module OmniScrapper
  module Normalizers
    class TokenizeByNewline < Base
      def call
        value.split("\r\n").map(&:strip)
      end
    end
  end
end
