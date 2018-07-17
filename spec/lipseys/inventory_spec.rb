require "spec_helper"

describe Lipseys::Inventory do

  let(:default_headers) { { 'Accept' => '*/*', 'Host' => 'www.lipseys.com' } }
  let(:options) { { username: '123', password: 'abc' } }

  before do
    stub_request(:get, "https://www.lipseys.com/API/pricequantitycatalog.ashx?email=123&pass=abc").
      with(headers: default_headers).to_return(status: 200, body: FixtureHelper.get_fixture_file('LipseysInventoryPricing.xml').read)
  end

  describe '.all' do
    it 'Yields each item to a block' do
      count = 0

      Lipseys::Inventory.all(options) do |item|
        count += 1
        case count
        when 1
          expect(item[:item_identifier]).to  eq('ABC00111')
          expect(item[:price]).to eq('500.00')
        when 2
          expect(item[:item_identifier]).to  eq('ABC00112')
          expect(item[:price]).to eq('400.00')
        end
      end

      expect(count).to eq(44)
    end
  end

end