module OmniScrapper
  class UnsupportedFrameworkException < StandardError
    def initialize(msg = 'This framework is not supported yet. Consider manual installation.')
      super
    end
  end
end
