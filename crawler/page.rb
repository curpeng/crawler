module Crawler
  class Page
    attr_reader :url, :inputs_count, :depth, :refers_to

    def initialize(url:, inputs_count:, refers_to: [], depth: 1)
      @url = url
      @inputs_count = inputs_count
      @depth = depth
      @refers_to = refers_to
    end
  end
end
