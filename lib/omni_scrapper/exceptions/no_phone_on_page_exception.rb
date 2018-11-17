module OmniScrapper
  class NoPhoneOnPageException < StandardError
    def initialize(value)
      @value = value
      super
    end

    def message
      "Invalid phone: #{@value}"
    end
  end
end
