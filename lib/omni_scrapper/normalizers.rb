require 'omni_scrapper/normalizers/phone'
require 'omni_scrapper/normalizers/integer'
require 'omni_scrapper/normalizers/strip'
require 'omni_scrapper/normalizers/tokenize_by_newline'
require 'omni_scrapper/normalizers/full_url'

module OmniScrapper
  module Normalizers
    class NormalizerNotFound < StandardError; end;

    def self.for(type)
      all[type.to_s] || raise(NormalizerNotFound, "No normalizer for #{type}")
    end

    def self.all
      {
        'phone' => OmniScrapper::Normalizers::Phone,
        'integer' => OmniScrapper::Normalizers::Integer,
        'strip' => OmniScrapper::Normalizers::Strip,
        'tokenize_by_newline' => OmniScrapper::Normalizers::TokenizeByNewline,
        'full_url' => OmniScrapper::Normalizers::FullUrl
      }
    end
  end
end
