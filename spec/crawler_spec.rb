require 'pry'
describe Crawler do
  subject { described_class }
  let(:base_url) { 'http://website.com/' }
  let(:url) { "#{base_url}home" }
  let(:home_inputs_count) { 20 }
  let(:faq_inputs_count) { 3 }
  let(:products_inputs_count) { 10 }
  let(:contact_inputs_count) { 5 }

  describe '.build_tree' do
    let(:root) { described_class.build_tree(url) }
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
      expect(root).to be_an_instance_of(Crawler::Page)
    end

    it 'returns root object that has correct number of references' do
      expect(root.refers_to.size).to eq(3)
    end

    context 'content of tree' do
      it 'returns root with inputs count that root page has' do
        expect(root.inputs_count).to eq(home_inputs_count)
      end

      it 'returns each reference with correct inputs count' do
        root.refers_to.each do |reference|
          key = reference.url.gsub('http://website.com/', '')
          expect(reference.inputs_count).to eq(root_refers_to[key.to_sym][:inputs_count])
        end
      end

      it 'returns each reference with correct number of references' do
        root.refers_to.each do |reference|
          key = reference.url.gsub(base_url, '')
          expect(reference.refers_to.size).to eq(root_refers_to[key.to_sym][:refers_to_size])
        end
      end
    end
  end

  describe 'print_inputs_counts' do
    let(:home_total_inputs_count) do
      home_inputs_count + faq_inputs_count + products_inputs_count + contact_inputs_count
    end

    let(:products_details_inputs_count) { 4 }
    let(:products_order_inputs_count) { 3 }

    let(:products_total_inputs_count) do
      products_inputs_count + products_details_inputs_count + products_order_inputs_count
    end

    let(:faq_in_details_inputs_count) { 3 }
    let(:faq_total_inputs_count) { faq_inputs_count + faq_in_details_inputs_count }

    let(:contact_call_me_inputs_count) { 3 }
    let(:contact_total_inputs_count) { contact_inputs_count + contact_call_me_inputs_count }

    it 'returns inputs count of root + inputs counts of references' do

      output_lines = [
        "#{base_url}home - #{home_total_inputs_count}",
        "#{base_url}products - #{products_total_inputs_count}",
        "#{base_url}products/details - #{products_details_inputs_count}",
        "#{base_url}products/order - #{products_order_inputs_count}",
        "#{base_url}faq - #{faq_total_inputs_count}",
        "#{base_url}faq/in_details - #{faq_in_details_inputs_count}",
        "#{base_url}contact - #{contact_total_inputs_count}",
        "#{base_url}contact/call_me - #{contact_call_me_inputs_count}"
      ]

      expect { subject.print_inputs_counts(url) }.to output(/#{output_lines.join("\n")}/).to_stdout
    end
  end
end
