module OmniScrapper
  module Normalizers
    class Base
      attr_accessor :value

      def initialize(value)
        self.value = value
      end

      def normalized
        fail 'Implement in child class'
      end
    end
  end
end
