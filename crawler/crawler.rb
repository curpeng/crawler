require 'concurrent/map'
require 'concurrent/executor/fixed_thread_pool'
require 'addressable/uri'

require_relative 'http_client'
require_relative 'parser'
require_relative 'page'
require_relative 'link'
require_relative 'site_map'

module Crawler
  class << self
    def print_inputs_counts(url)
      map = SiteMap.new(url).build
      map.each_value do |page|
        children_inputs_count = page.refers_to.inject(0) do |sum, child_url|
          child = map[child_url]
          sum = sum + child.inputs_count if child
          sum
        end
        puts "#{page.url} - #{page.inputs_count + children_inputs_count}"
      end
      nil
    end
  end
end
