require 'haml'

describe Crawler::Parser do
  let(:file_name) { 'home.html.haml' }
  let(:file) { File.read(File.dirname(__FILE__) + '/fixtures/' + file_name) }
  let(:html) { Haml::Engine.new(file).render }

  subject { described_class.new(html) }

  describe '#get_links' do
    it 'returns array with correct number of links' do
      expect(subject.get_links.size).to eq(3)
    end
  end

  describe '#get_inputs' do
    it 'returns array with correct number of inputs' do
      expect(subject.get_inputs.size).to eq(20)
    end
  end
end
