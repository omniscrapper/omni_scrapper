module OmniScrapper
  module FileUtils
    BASE_NAME = ''
    DIRS = %w( schemas crawlers scrappers normalizers )

    class << self
      def install
        Dir.mkdir(installation_location)
        DIRS.each do |dir|
          Dir.mkdir("#{installation_location}/#{dir}")
        end
      end

      def generate_scrapper(name)
        Dir.mkdir("#{installation_location}/scrappers/#{name}")
        File.open("#{installation_location}/scrappers/#{name}/scrapper.rb", "w+") do |f|
          f.write(scrapper_template(name))
        end

        File.open("#{installation_location}/scrappers/#{name}/scrap_methods.rb", "w+") do |f|
          f.write(scrap_methods_template(name))
        end
      end

      def userspace_files
        Dir.glob(File.join(installation_location, "**", "*.rb"))
      end

      def installed?
        Dir.exists?(installation_location)
      end

      def installation_location
        if hanami?
          'apps/scrappers'
        elsif rails?
          fail OmniScrapper::UnsupportedFrameworkException, 'Rails is not supported yet.'
        else
          fail OmniScrapper::UnknownFrameworkException
        end
      end

      def hanami?
        defined? Hanami
      end

      def rails?
        defined? Rails
      end

      def scrapper_template(name)
        <<-TEMPLATE
require_relative '../gallery'
require_relative '../schema'

# Usage example:
# Scrappers::#{name}::Scrapper.run { |data| p data }
module Scrappers
  module #{name}
    class Scrapper < ::Scrappers::Gallery
      include OmniScrapper

      setup do |config|
        config.schema ::Scrappers::Schema
        config.crawler ::Scrappers::Gallery

        config.entrypoint ''
        config.next_page_link ''

        config.field :name,
          selector: ''
      end
    end
  end
end
        TEMPLATE
      end

      def scrap_methods_template(name)
        <<-TEMPLATE
module ScrapMethods
end
        TEMPLATE
      end
    end
  end
end
