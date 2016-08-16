require 'sinatra/base'
require 'haml'

class FakeWebSite < Sinatra::Base
  get '/home' do
    http_response 200, 'home.html.haml'
  end

  get '/faq' do
    http_response 200, 'faq.html.haml'
  end

  get '/faq/in_details' do
    http_response 200, 'faq/in_details.html.haml'
  end

  get '/products' do
    http_response 200, 'products.html.haml'
  end

  get '/products/details' do
    http_response 200, 'products/details.html.haml'
  end

  get '/products/order' do
    http_response 200, 'products/order.html.haml'
  end

  get '/contact' do
    http_response 200, 'contact.html.haml'
  end

  get '/contact/call_me' do
    http_response 200, 'contact/call_me.html.haml'
  end

  private

  def http_response(response_code, file_path)
    content_type :json
    status response_code

    file = File.read(File.dirname(__FILE__).gsub('/support', '') + '/fixtures/' + file_path)
    Haml::Engine.new(file).render
  end
end
