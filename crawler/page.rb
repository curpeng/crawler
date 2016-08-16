module Crawler
  class Page
    attr_reader :url, :inputs_count, :parent, :depth, :refers_to

    def initialize(url:, inputs_count:, parent: nil, depth: 1)
      @url = url
      @inputs_count = inputs_count
      @parent = parent
      @depth = depth
      @refers_to = []
    end

    def add_reference(page)
      @refers_to << page
    end

    def each_page &block
      yield(self)

      refers_to.each { |page| page.each_page &block }
    end
  end
end
