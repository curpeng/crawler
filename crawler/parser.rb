require 'nokogiri'

module Crawler
  class Parser
    def initialize(raw_html)
      @page = Nokogiri::HTML(raw_html)
    end

    def get_links
      @links ||= @page.css('a').map { |link| link['href'] }.uniq.delete_if { |href| href.empty? }
    end

    def get_inputs
      @inputs_count ||= @page.css('input')
    end
  end
end
