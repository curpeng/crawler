require 'sinatra/base'

class FakeWebSite < Sinatra::Base
  get '/main' do
    http_response 200, 'main.html.haml'
  end

  private

  def http_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__).gsub('/support', '') + '/fixtures/' + file_name).read
  end
end
