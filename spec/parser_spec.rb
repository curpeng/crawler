require 'haml'

describe Crawler::Parser do
  let(:file_name) { 'home.html.haml' }
  let(:file) { File.read(File.dirname(__FILE__) + '/fixtures/' + file_name) }
  let(:html) { Haml::Engine.new(file).render }
  let(:base_url) { 'http://website.com/home' }
  let(:host) { Addressable::URI.parse(base_url).host }
  let(:link_with_differ_host) { 'http://vkontakte.com/group' }

  subject { described_class.new(html) }

  describe '#get_links' do
    it 'returns array with correct number of links' do
      expect(subject.get_links(host).size).to eq(3)
    end

    it "shouldn't include links with differ hosts" do
      expect(subject.get_links(host)).to_not include(link_with_differ_host)
    end

    it 'should return all links as absolute links' do
      subject.get_links(host).each do |link|
        expect(link).to include('http://')
      end
    end
  end

  describe '#get_inputs' do
    it 'returns array with correct number of inputs' do
      expect(subject.get_inputs.size).to eq(20)
    end
  end
end
