module OmniScrapper
  # It creates an instance of new Scrapper class with defined configuration.
  class ScrapperBuilder
    attr_reader :scrapper_name, :config

    def initialize(scrapper_name, config)
      @scrapper_name = scrapper_name
      @config = config
    end

    def build_class
      generate_class(scrapper_name, config)
    end

    private

    def generate_class(scrapper_name, config)
      Class.new(crawler) do
        config.anchors.each do |name, options|
          define_method("#{name}_pattern") do
            options[:pattern]
          end
        end

        define_method :configuration do
          config
        end

        define_method :name do
          scrapper_name
        end
      end
    end

    def crawler
      ::OmniScrapper::Crawlers.by_name(config.crawler)
    end
  end
end
