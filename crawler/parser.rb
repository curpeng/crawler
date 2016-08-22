require 'nokogiri'

module Crawler
  class Parser
    def initialize(raw_html)
      @page = Nokogiri::HTML(raw_html)
    end

    def get_links(host)
      @links ||= @page.css('a').map { |link| link['href'] }.uniq.delete_if do |href|
        href.nil? || href.empty? || !within_the_same_host?(host, href)
      end

      @links.map! { |l| to_absolute_url(host, l) }
    end

    def get_inputs
      @inputs_count ||= @page.css('input')
    end

    private

    def within_the_same_host?(host, href)
      link = Addressable::URI.parse(href)
      link.host == host || !link.absolute?
    end

    def to_absolute_url(host, href)
      http = 'http://'
      return href if Addressable::URI.parse(href).absolute?
      return http + host if href == '/'

      http + host + href
    end
  end
end
