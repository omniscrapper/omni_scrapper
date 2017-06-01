require 'omni_scrapper/file_utils'

namespace :omni_scrapper do
  desc 'Generate scrapper'
  task :generate, :name do |t, args|
    if OmniScrapper::FileUtils.installed?
      OmniScrapper::FileUtils.generate_scrapper(args[:name])
      p 'Scrapper is generated'
    else
      p 'OmniScrapper is not installed. Please run `rake omni_scrapper:install` before.'
    end
  end
end
