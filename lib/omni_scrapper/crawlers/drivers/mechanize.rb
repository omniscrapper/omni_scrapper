require 'mechanize'

module OmniScrapper
  module Crawlers
    module Drivers
      module Mechanize
        attr_accessor :agent

        def prepare_driver
          self.agent = ::Mechanize.new
          self.agent.keep_alive = false
        end

        def set_proxy(host, port)
          self.agent.set_proxy(host, port)
        end

        def set_user_agent(user_agent)
          # TODO: make user agent configurable explicitly, or rotate a list of
          # predefined values on each call, or via other rotation policy.
          self.agent.user_agent_alias = user_agent
        end

        def visit(url)
          self.current_page = agent.get(url)
        end

        def urls_with_pattern(pattern)
          agent.current_page.xpath(pattern)
            .map { |a| url_to(a.attribute('href').value) }
        end

        def current_page_body
          agent.current_page.body
        end

        def current_uri
          URI(agent.current_page.canonical_uri)
        end

        def url_to(path)
          path_uri = URI(path)
          return path unless path_uri.host == nil
          result = URI("#{current_uri.scheme}://#{current_uri.host}#{path}")
          result.to_s
        rescue URI::InvalidURIError
          ''
        end
      end
    end
  end
end
