require "spec_helper"

describe Lipseys::Catalog do

  let(:default_headers) { { 'Accept' => '*/*', 'Host' => '184.188.80.195' } }
  let(:options) { { username: '123', password: 'abc' } }

  before do
    stub_request(:get, "http://184.188.80.195/API/catalog.ashx?email=123&pass=abc").
      with(headers: default_headers).to_return(status: 200, body: FixtureHelper.get_fixture_file('LipseysCatalog.xml').read)

    stub_request(:get, "http://184.188.80.195/API/pricequantitycatalog.ashx?email=123&pass=abc").
      with(headers: default_headers).to_return(status: 200, body: FixtureHelper.get_fixture_file('LipseysInventoryPricing.xml').read)
  end

  describe '.all' do
    it 'returns an array of all items' do
      items = Lipseys::Catalog.all(options)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:upc]).to  eq('968000000001')
          expect(item[:name]).to eq('A00111 TWIYO A00111')
        when 1
          expect(item[:upc]).to  eq('968000000002')
          expect(item[:name]).to eq('A00112 RHYZIO A00112')
        end
      end

      expect(items.count).to eq(44)
    end
  end

end
