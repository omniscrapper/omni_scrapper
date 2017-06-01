module OmniScrapper
  class UnknownFrameworkException < StandardError
    def initialize(msg = 'Uknown framework. Do not know where to generate directory structure.')
      super
    end
  end
end
