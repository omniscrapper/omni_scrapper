module OmniScrapper
  # Extracts and transforms data from the page according to configuration
  class Page
    attr_accessor :body, :uri, :page, :config

    # TODO: move uri and id_within_site extraction to crawler
    def initialize(uri, body, config)
      self.body = body
      self.uri = uri
      self.config = config
    end

    def data
      self.page = parse_html(body)
      result_data = prepare_data
    end

    private

    def parse_html(body)
      Nokogiri::HTML(body)
    end

    # TODO: pass fields array instead of the whole config to page
    def prepare_data
      config.fields.reduce({}) do |result, (field_name, field_options)|
        next result if field_options[:selector] == ''
        value = get_field(field_options)
        result.merge(field_name => value)
      end.merge(id_within_site: id_within_site)
    end

    def id_within_site
      extract(self.uri.to_s, config.anchors[:id_within_site][:pattern])
    end

    def get_field(options)
      return options[:value] if options[:value]
      return __send__(options[:method], body) if options[:method]
      return options[:do].call(body) if options[:do]

      value = find(options[:selector])
      value = normalize(value, options[:normalizer])
      value = extract(value, options[:pattern])
      value = type_cast(value, options[:type_cast_to])
      value
    end

    def find(selector)
      page.xpath(selector).text.strip
    end

    def extract(value, pattern)
      return value unless pattern
      pattern = ::Regexp.new(pattern) if pattern.class == String 
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
        # TODO: take normalizer from repository instead of objectspace
        normalizer_class = normalizers_namespace.const_get(normalizer_name)
        normalizer_class.new(value).normalized
      when Proc
        normalizer.call(value)
      when NilClass
        value
      end
    end

    # TODO: create repo
    def normalizers_namespace
      root_namespace.const_get('Normalizers')
    end

    def root_namespace
      @root_namespace ||= Kernel.const_get('OmniScrapper')
    end
  end
end
