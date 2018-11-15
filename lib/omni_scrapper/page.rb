module OmniScrapper
  class Page
    attr_accessor :page, :config

    def initialize(page, config)
      self.page = page
      self.config = config
    end

    def data
      result_data = prepare_data
      validate_data!(result_data)
    end

    private

    # TODO: should be moved to scrapper
    def prepare_data
      config.fields.reduce({}) do |result, (field_name, field_options)|
        value = get_field(field_options)
        result.merge(field_name => value)
      end.merge(id_within_site: id_within_site)
    end

    def validate_data!(result_data)
      # TODO: Fix this is not working
      # schema_pattern method is not available here
      # uncomment when move this to scrapper level
      config.schema.new.validate!(result_data) if config.schema
      result_data
    end

    def id_within_site
      extract(page.uri.to_s, config.anchors[:id_within_site][:pattern])
    end

    def get_field(options)
      return options[:value] if options[:value]
      return __send__(options[:method], page) if options[:method]
      return options[:do].call(page) if options[:do]

      value = find(options[:selector])
      value = normalize(value, options[:normalizer])
      value = extract(value, options[:pattern])
      value = type_cast(value, options[:type_cast_to])
      value
    end

    def find(selector)
      selector = selector.gsub('/tbody', '')
      page.xpath(selector).text.strip
    end

    def extract(value, pattern)
      return value unless pattern
      value.scan(pattern).flatten.first
    end

    def type_cast(value, type_class)
      return value unless type_class

      case type_class.to_s
      when 'Integer'
        value.to_i
      else
        value
      end
    end

    def normalize(value, normalizer)
      case normalizer
      when Class
        normalizer.new(value).normalized
      when Symbol
        normalizer_name = normalizer.to_s.split('_').map { |w| w.capitalize }.join
        normalizer_class = normalizers_namespace.const_get(normalizer_name)
        normalizer_class.new(value).normalized
      when Proc
        normalizer.call(value)
      when NilClass
        value
      end
    end

    def normalizers_namespace
      root_namespace.const_get('Normalizers')
    end

    def root_namespace
      @root_namespace ||= Kernel.const_get('OmniScrapper')
    end
  end
end
