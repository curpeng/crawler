require_relative 'http_client'
require_relative 'parser'
require_relative 'page'

module Crawler
  PAGE_LIMIT = 50.freeze
  DEPTH_LIMIT = 3.freeze
  Info = Struct.new(:page, :serial_number)

  class << self
    def print_inputs_counts(url)
      tree = build_tree(url)
      tree.each_page do |page|
        puts "#{page.url} - #{ page.inputs_count + page.refers_to.inject(0) {|sum, r| sum + r.inputs_count }}"
      end
      nil
    end

    def build_tree(url)
      parse_page(url).page
    end

    private

    def parse_page(url, parent = nil, depth = 1, serial_number = 1)
      response = client.get(url)

      return if response.nil?

      parser = Parser.new(response.body)

      parent = Page.new(
        url: url,
        parent: parent,
        depth: depth,
        inputs_count: parser.get_inputs.size
      )

      if depth <= DEPTH_LIMIT
        depth += 1

        parser.get_links.each do |link|
          break if serial_number >= PAGE_LIMIT
          serial_number += 1

          info = parse_page(link, parent, depth, serial_number)
          serial_number = info.serial_number
          parent.add_reference(info.page)
        end
      end

      Info.new(parent, serial_number)
    end

    def client
      @client ||= HttpClient.new
    end
  end
end
