module Crawler
  class Link
    attr_reader :url, :depth

    def initialize(url, depth = 1)
      @url = url
      @depth = depth
    end
  end
end
