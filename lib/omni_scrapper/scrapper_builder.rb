module OmniScrapper
  class ScrapperBuilder
    attr_accessor :scrapper_name, :config

    def initialize(scrapper_name, config)
      self.scrapper_name = scrapper_name
      self.config = config
    end

    def define_classes
      define_scrapper_class(scrapper_name, config)
      define_page_class
    end

    private

    def define_scrapper_class(scrapper_name, config)
      current_module = scrapper_module
      klass = Class.new(config.crawler) do
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
    end

    def define_page_class
      page_class = scrapper_module.const_set('Page', Class.new(OmniScrapper::Page))
      page_class.__send__(:include, class_methods_module) if scrapper_module.const_defined?('ScrapMethods')
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

    def class_methods_module
      @class_methods_module ||= Object.const_get scrapper_module_array.push('ScrapMethods').join('::')
    end

    def scrapper_module_array
      [scrappers_namespace_name.to_s, classify_name(scrapper_name)]
    end

    def classify_name(name)
      name.to_s.split('_').map { |w| w.capitalize }.join
    end
  end
end
