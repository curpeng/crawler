require 'pry'
describe Crawler do
  subject { described_class }
  let(:base_url) { 'http://website.com/' }
  let(:url) { "#{base_url}home" }
  let(:home_inputs_count) { 20 }
  let(:faq_inputs_count) { 3 }
  let(:products_inputs_count) { 10 }
  let(:contact_inputs_count) { 5 }

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

      output_lines.each do |line|
        expect { subject.print_inputs_counts(url) }.to output(/#{line}/).to_stdout
      end
    end
  end
end
