require 'mechanize'

module OmniScrapper
  module Crawlers
    module Drivers
      module Mechanize
        attr_accessor :agent

        def prepare_driver
          # TODO: make user agent configurable explicitly, or rotate a list of
          # predefined values on each call, or via other rotation policy.
          self.agent = ::Mechanize.new
          self.agent.keep_alive = false
        end

        def set_proxy(host, port)
          self.agent.set_proxy(host, port)
        end

        def set_user_agent(user_agent)
          self.agent.user_agent_alias = 'Mac Safari'
        end
      end
    end
  end
end
