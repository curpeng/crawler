describe Crawler::HttpClient do
  subject { described_class.new }

  describe '#get' do
    it 'returns nil if something went wrong' do
      allow_any_instance_of(Faraday::Connection).to receive(:get)
        .and_raise('Unsupported')

      expect(subject.get('some_url')).to be_nil
    end
  end
end
