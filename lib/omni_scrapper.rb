require 'mechanize'
require 'omni_scrapper/normalizers'
require 'omni_scrapper/result'
require 'omni_scrapper/file_utils'
require 'omni_scrapper/page'
require 'omni_scrapper/schema'
require 'omni_scrapper/configuration'
require 'omni_scrapper/scrapper_builder'
require 'omni_scrapper/scrapper'

OmniScrapper::FileUtils.userspace_files.each { |file| require("./#{file}") }
