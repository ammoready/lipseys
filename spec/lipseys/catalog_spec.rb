require "spec_helper"

describe Lipseys::Catalog do

  let(:options) { { username: '123', password: 'abc' } }

  before do
    stub_request(:get, "https://www.lipseys.com/API/catalog.ashx?email=123&pass=abc").
      with(headers: default_headers).to_return(status: 200, body: sample_catalog_response)

    stub_request(:get, "https://www.lipseys.com/API/pricequantitycatalog.ashx?email=123&pass=abc").
      with(headers: default_headers).to_return(status: 200, body: sample_inventory_response)
  end

  describe '.all' do
    it 'Returns a hash of data' do
      Lipseys::Catalog.all(10, options) do |chunk|
        chunk.each_with_index do |item, index|
          case index
          when 0
            expect(item[:upc]).to  eq('082442188744')
            expect(item[:name]).to eq('21 Bobcat J212500')
          when 1
            expect(item[:upc]).to  eq('082442188812')
            expect(item[:name]).to eq('3032 Tomcat J320500')
          end
        end
      end
    end
  end

end
