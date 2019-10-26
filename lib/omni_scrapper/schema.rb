require 'json-schema'

module OmniScrapper
  class Schema
    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end

    def validate!(data)
      JSON::Validator.validate!(definition, data)
    end
  end
end
