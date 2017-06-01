module OmniScrapper
  class InvalidFieldArgumentsException < StandardError
    def initialize(msg = 'Invalid field arguments')
      super
    end
  end
end
