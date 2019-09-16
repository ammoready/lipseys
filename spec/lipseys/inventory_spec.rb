require "spec_helper"

describe Lipseys::Inventory do

  let(:default_headers) { { 'Accept' => '*/*', 'Host' => '184.188.80.195' } }
  let(:options) { { username: '123', password: 'abc' } }

  before do
    stub_request(:get, "http://184.188.80.195/API/pricequantitycatalog.ashx?email=123&pass=abc").
      with(headers: default_headers).to_return(status: 200, body: FixtureHelper.get_fixture_file('LipseysInventoryPricing.xml').read)
  end

  describe '.all' do
    it 'returns an array of items' do
      items = Lipseys::Inventory.all(options)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:item_identifier]).to  eq('ABC00111')
          expect(item[:price]).to eq('500.00')
        when 1
          expect(item[:item_identifier]).to  eq('ABC00112')
          expect(item[:price]).to eq('400.00')
        end
      end

      expect(items.count).to eq(44)
    end
  end

end
