module Crawler
  class Page
    attr_reader :url, :inputs_count, :parent, :depth, :refers_to

    def initialize(url:, inputs_count:, parent: nil, depth: 1)
      @url = url
      @inputs_count = inputs_count
      @parent = parent
      @depth = depth
      @refers_to = [] # maybe should be a queue
    end

    def add_reference(page)
      @refers_to << page
    end
  end
end
