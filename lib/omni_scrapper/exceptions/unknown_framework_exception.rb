module OmniScrapper
  class UnknownFrameworkException < StandardError
    def initialize(msg = 'Unknown framework. Do not know where to generate directory structure.')
      super
    end
  end
end
