module OmniScrapper
  # Extracts and adjusts specific field from page
  class Field
    attr_reader :page, :name, :schema,
      :selector, :normalizer, :pattern, :type_cast_to,
      :url

    def initialize(url, schema_definition, page, name, options = {})
      @schema = Schema.new(schema_definition)
      @page   = page
      @name   = name
      @url    = url

      @selector = options[:selector]
      @normalizer = options[:normalizer]
      @pattern = options[:pattern]
      @type_cast_to = options[:type_cast_to]
    end

    def value
      val = find
      val = extract(val)
      val = normalize(val)
      type_cast(val)
    end

    private

    def find
      if field_type == 'array'
        page.xpath(selector).map { |n| n.text.strip }
      else
        page.xpath(selector).text.strip
      end
    end

    def extract(val)
      return val if empty?(pattern)
      regex = pattern.class == String ? ::Regexp.new(pattern) : pattern
      val.scan(regex).flatten.first
    end

    def type_cast(val)
      case field_type.to_s
      when 'integer'
        val.to_i
      when 'string'
        val.to_s
      when 'array'
        val.flatten
      else
        val
      end
    end

    def normalize(val)
      return val if empty?(normalizer)
      options = { url: url }
      normalizer_class = OmniScrapper::Normalizers.for(normalizer)

      if field_type == 'array'
        val.map { |v| normalizer_class.new(v, options).call }
      else
        normalizer_class.new(val, options).call
      end
    end

    def field_type
      schema.type_for(name)
    end

    def empty?(val)
      ['', nil].include?(val)
    end
  end
end
