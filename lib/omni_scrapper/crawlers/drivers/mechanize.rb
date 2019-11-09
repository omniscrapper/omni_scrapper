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

        # TODO: unify naming of this and next methods
        def urls_with_pattern(pattern)
          agent.current_page
            .xpath(pattern)
            .map do |a|
              url_to(a.attribute('href').value)
            end
        end

        def link_url(pattern)
          path = agent.current_page
            .xpath(pattern)
            &.last
            &.attribute('href')
            .to_s
          url_to path
        end

        def current_page_body
          agent.current_page.body
        end

        def current_uri
          URI(agent.current_page.uri)
        end
      end
    end
  end
end
