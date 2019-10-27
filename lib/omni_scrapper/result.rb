module OmniScrapper
  # Represents the final state of dataset, which will be transferred to
  # and external storage
  class Result
    attr_accessor :scrapper_name, :data, :timestamp, :checksum

    def initialize(scrapper_name)
      self.scrapper_name = scrapper_name
      self.timestamp = Time.now
    end

    def build(data)
      self.data = data
      self.checksum = Signature.new(data).calculate
    end

    private

    class Signature
      attr_accessor :data

      def initialize(data)
        self.data = data
      end

      def calculate
        Digest::MD5.hexdigest(data.to_s)
      end
    end
  end
end
