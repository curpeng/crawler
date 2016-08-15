require 'faraday'
require 'faraday_middleware'

module Crawler
  class HttpClient
    DEFAULT_CA_PATH = '/etc/ssl/certs/'.freeze

    def initialize
      opts = {
        ssl: { ca_path: ENV['ca_path'] || DEFAULT_CA_PATH }
      }

      @connection = Faraday.new(opts) do |c|
        c.response :logger
        c.use ::FaradayMiddleware::FollowRedirects
        c.adapter Faraday.default_adapter
      end
    end

    def get(url)
      @connection.get(url)
    rescue
      nil
    end
  end
end
