module OmniScrapper
  class ScrapperBuilder
    attr_accessor :scrapper_name, :config

    def initialize(scrapper_name, config)
      self.scrapper_name = scrapper_name
      self.config = config
    end

    def define_classes
      define_root_namespace
      define_scrapper_class(scrapper_name, config)
    end

    private

    def define_root_namespace
      root = Object.const_set(scrappers_namespace_name, Module.new)
      root.const_set(classify_name(scrapper_name), Module.new)
    end

    def define_scrapper_class(scrapper_name, config)
      current_module = scrapper_module
      crawler = ::OmniScrapper::Crawlers.by_name(config.crawler)

      klass = Class.new(crawler) do
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

        define_method :scrapper_page_class do
          current_module.const_get('Page')
        end
      end

      Object.const_set(scrappers_namespace_name, Module.new) unless defined? scrappers_namespace_module
      scrappers_namespace_module.const_set(classify_name(scrapper_name), Module.new) unless defined? scrapper_module
      scrapper_module.const_set(scrapper_class_name, klass)
      klass
    end

    def scrappers_namespace_module
      @scrappers_namespace_module ||= Object.const_get(scrappers_namespace_name)
    end

    def scrappers_namespace_name
      :Scrappers
    end

    def scrapper_class_name
      :Scrapper
    end

    def scrapper_module
      @scrapper_module ||= Object.const_get("#{scrappers_namespace_name}::#{classify_name(scrapper_name)}")
    end

    def classify_name(name)
      name.to_s.split('_').map { |w| w.capitalize }.join
    end
  end
end
