require_relative 'base'

module OmniScrapper
  module Normalizers
    # Extracts integer part from passed string
    class Integer < Base
      class NotFoundError < StandardError; end;

      TYPE_REGEX = ::Regexp.new(/(\d{1,5})/)

      def call
        extracted_value.tap do |result|
          raise(NotFoundError, "Integer part not found at: '#{value}'") unless result
        end
      end

      private

      def extracted_value
        value.scan(TYPE_REGEX).flatten.first.to_i
      end
    end
  end
end
