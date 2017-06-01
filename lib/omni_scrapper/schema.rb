require 'json-schema'

module OmniScrapper
  class Schema
    def validate!(data)
      JSON::Validator.validate!(schema, data)
    end

    def schema
      fail 'Implement in child class'
    end
  end
end
