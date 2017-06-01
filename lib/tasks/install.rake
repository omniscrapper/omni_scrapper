require 'omni_scrapper/file_utils'

namespace :omni_scrapper do
  desc 'Install'
  task :install do
    if defined? Hanami
      p 'Hanami framework detected.'

      if OmniScrapper::FileUtils.installed?
        p 'OmniScrapper is already installed'
      else
        p 'Installing'
        OmniScrapper::FileUtils.install
      end
    end
  end
end
