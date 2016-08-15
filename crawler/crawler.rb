require_relative 'http_client'
require_relative 'parser'
require_relative 'page'

module Crawler
  PAGE_LIMIT = 10.freeze
  DEPTH_LIMIT = 3.freeze

  class << self
    def parse(url)
      parse_page(url)
    end

    private

    def parse_page(url, parent = nil, depth = 1, page_number = 1)
      response = client.get(url)

      return if response.nil?

      parser = Parser.new(response.body)

      parent = Page.new(
        url: url,
        parent: parent,
        depth: depth,
        inputs_count: parser.get_inputs.size
      )

      unless depth == DEPTH_LIMIT
        depth += 1
        parser.get_links.each do |link|
          break if page_number == PAGE_LIMIT
          page_number += 1
          child = parse_page(link, parent, depth, page_number)
          parent.add_reference(child) if child
        end
      end

      parent
    end

    def client
      @client ||= HttpClient.new
    end
  end
end
