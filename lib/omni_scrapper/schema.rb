require 'json-schema'
require 'json'

module OmniScrapper
  class Schema
    attr_reader :definition

    def initialize(definition)
      @definition = symbolize_keys(definition)
    end

    def validate!(data)
      JSON::Validator.validate!(definition, data)
    end

    def type_for(field)
      @definition[:properties][field.to_sym][:type]
    end

    private

    def symbolize_keys(hash)
      json = JSON.generate(hash)
      JSON.parse(json, symbolize_names: true)
    end
  end
end
