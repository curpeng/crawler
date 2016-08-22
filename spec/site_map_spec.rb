describe Crawler::SiteMap do
  let(:url) { 'http://website.com/home' }
  let(:home_inputs_count) { 20 }
  let(:faq_inputs_count) { 3 }
  let(:products_inputs_count) { 10 }
  let(:contact_inputs_count) { 5 }
  subject { described_class.new(url) }

  describe '#build' do
    let(:root_refers_to) do
      {
        faq: {
          inputs_count: faq_inputs_count,
          refers_to_size: 1,
        },
        products: {
          inputs_count: products_inputs_count,
          refers_to_size: 2,
        },
        contact: {
          inputs_count: contact_inputs_count,
          refers_to_size: 1,
        }
      }
    end

    it 'returns instance of Page class' do
      expect(subject.build).to be_an_instance_of(Concurrent::Map)
    end

    context 'site map' do
      context 'root page' do
        it 'sets inputs_count for root page' do
          expect(subject.build[url].inputs_count).to eq(home_inputs_count)
        end

        it 'fills in refers_to with correct amount of links for root page' do
          expect(subject.build[url].refers_to.size).to eq(root_refers_to.keys.size)
        end
      end

      context "root's references" do
        it 'returns each reference with correct inputs count' do
          site_map = subject.build
          site_map[url].refers_to.each do |reference|
            key = reference.gsub('http://website.com/', '')
            expect(site_map[reference].inputs_count).to eq(root_refers_to[key.to_sym][:inputs_count])
          end
        end

        it 'returns each reference with correct number of references' do
          site_map = subject.build
          site_map[url].refers_to.each do |reference|
            key = reference.gsub('http://website.com/', '')
            expect(site_map[reference].refers_to.size).to eq(root_refers_to[key.to_sym][:refers_to_size])
          end
        end
      end
    end
  end
end
