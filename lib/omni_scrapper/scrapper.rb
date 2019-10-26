require 'omni_scrapper/proxy'

# This module is an entry-point of the whole OmniScrapper gem.
# It provides a public interface for any gem user, who want to interact with scrappers.
module OmniScrapper
  def self.included(base)
    base.extend(OmniScrapper::ClassMethods)
  end

  class << self
    # Builds a bunch of omni_scrapper classes based on provided configuration
    def setup(scrapper_name)
      config = OmniScrapper::Configuration.new
      yield(config)
      OmniScrapper::ScrapperBuilder.new(scrapper_name, config).define_classes
    end
  end

  module ClassMethods
    def run(&block)
      new.run(&block)
    end
  end

  def initialize(entrypoint_url = nil)
    self.entrypoint = entrypoint_url || entrypoint_pattern
    self.agent = Mechanize.new do |a|
      a.user_agent_alias = 'Mac Safari'
    end
    self.agent.set_proxy(Proxy.host, Proxy.port) if Proxy.enabled?
  end

  def scrap_page(page)
    puts "Scrapping #{page.uri.to_s}"
    data = Page.new(page, configuration).data
    OmniScrapper::Result.new(name).tap { |result| result.build(data) }
  end
end
