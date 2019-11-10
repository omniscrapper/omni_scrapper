require_relative 'field'

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
      prepare_data
    end

    private

    def parse_html(body)
      Nokogiri::HTML(body)
    end

    # TODO: pass fields array instead of the whole config to page
    def prepare_data
      config.fields.reduce({}) do |result, (field_name, field_options)|
        next result if field_options[:selector] == ''
        field = Field.new(uri, config.schema, page, field_name, field_options)
        result.merge(field_name => field.value)
      end.merge(id_within_site: id_within_site)
    end

    def id_within_site
      extract(self.uri.to_s, config.anchors[:id_within_site][:pattern])
    end

    def extract(value, pattern)
      return value unless pattern
      pattern = ::Regexp.new(pattern) if pattern.class == String 
      value.scan(pattern).flatten.first
    end
  end
end
