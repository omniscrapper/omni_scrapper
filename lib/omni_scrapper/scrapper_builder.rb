module OmniScrapper
  class ScrapperBuilder
    attr_accessor :scrapper_name, :config

    def initialize(scrapper_name, config)
      self.scrapper_name = scrapper_name
      self.config = config
    end

    def define_classes
      define_scrapper_class(scrapper_name, config)
    end

    private

    def define_scrapper_class(scrapper_name, config)
      crawler = ::OmniScrapper::Crawlers.by_name(config.crawler)

      Class.new(crawler) do
        include OmniScrapper

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
  end
end
