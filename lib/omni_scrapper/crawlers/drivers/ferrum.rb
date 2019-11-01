require 'ferrum'

module OmniScrapper
  module Crawlers
    module Drivers
      module Ferrum
        attr_accessor :agent

        def prepare_driver
          # TODO: probably we need additional class Driver,
          # which encapsulates all agent specific calls
          self.agent = ::Ferrum::Browser.new
        end

        # TODO: delegate those methods from crawler to agent
        def set_proxy(host, port)
          #self.agent.set_proxy(host, port)
        end

        def set_user_agent(user_agent)
          #self.agent.user_agent_alias = 'Mac Safari'
        end

        def visit(url)
          agent.goto(url)
        end

        def urls_with_pattern(pattern)
          agent.at_xpath(pattern)
        end
      end
    end
  end
end
