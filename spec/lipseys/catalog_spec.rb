require "spec_helper"

describe Lipseys::Catalog do

  let(:default_headers) { { 'Accept' => '*/*', 'Host' => 'www.lipseys.com' } }
  let(:options) { { username: '123', password: 'abc' } }

  before do
    stub_request(:get, "https://www.lipseys.com/API/catalog.ashx?email=123&pass=abc").
      with(headers: default_headers).to_return(status: 200, body: FixtureHelper.get_fixture_file('LipseysCatalog.xml').read)

    stub_request(:get, "https://www.lipseys.com/API/pricequantitycatalog.ashx?email=123&pass=abc").
      with(headers: default_headers).to_return(status: 200, body: FixtureHelper.get_fixture_file('LipseysInventoryPricing.xml').read)
  end

  describe '.all' do
    it 'Yields each item to a block' do
      count = 0

      Lipseys::Catalog.all(options) do |item|
        count += 1
        case count
        when 1
          expect(item[:upc]).to  eq('968000000001')
          expect(item[:name]).to eq('A00111 TWIYO A00111')
        when 2
          expect(item[:upc]).to  eq('968000000002')
          expect(item[:name]).to eq('A00112 RHYZIO A00112')
        end
      end

      expect(count).to eq(44)
    end
  end

end
