module OmniScrapper
  module Normalizers
    class Base
      attr_reader :value, :options

      def initialize(value, options = {})
        @value = value
        @options = options
      end

      def call
        fail 'Implement in child class'
      end
    end
  end
end
