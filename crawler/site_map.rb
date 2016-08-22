module Crawler
  class SiteMap
    PAGE_LIMIT = 50.freeze
    DEPTH_LIMIT = 3.freeze

    attr_reader :links_queue, :pages_queue, :pages_dictionary
    def initialize(url, page_limit: PAGE_LIMIT, depth_limit: DEPTH_LIMIT)
      @root_url = url
      @host = Addressable::URI.parse(@root_url).host
      @page_limit = page_limit
      @depth_limit = depth_limit

      @pages_dictionary = Concurrent::Map.new
      @links_queue = Queue.new  # queue of links for fetching
      @pages_queue = Queue.new  # queue of fetched pages

      @pool_size = 4
      @pool = Concurrent::FixedThreadPool.new(@pool_size)

      @links_queue << Link.new(@root_url)
    end

    def build
      @pool_size.times { fetch_links }

      loop do
        if @pages_dictionary.size == @page_limit
          @pool.shutdown
          break
        end

        if !@pages_queue.empty?
          page = @pages_queue.pop
          @pages_dictionary[page.url] = page

        elsif @links_queue.empty?
          if @links_queue.num_waiting != @pool_size
            Thread.pass
          else
            @pool.shutdown
            break
          end
        end
      end

      @pages_dictionary
    end
    private

    def fetch_links
      @pool.post do
        loop do
          link = @links_queue.pop
          page = parse_page(link)

          if page
            page.refers_to.each do |l|
              if link.depth < @depth_limit
                @links_queue << Link.new(l, link.depth + 1)
              end
            end
            @pages_queue << page
          end
        end
      end
    end

    def parse_page(link)
      response = client.get(link.url)

      return if response.nil?

      parser = Parser.new(response.body)
      Page.new(
        url: link.url,
        depth: link.depth,
        inputs_count: parser.get_inputs.size,
        refers_to: parser.get_links(@host)
      )
    end

    def client
      @client ||= HttpClient.new
    end
  end
end
