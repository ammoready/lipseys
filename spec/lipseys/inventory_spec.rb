require "spec_helper"

describe Lipseys::Inventory do

  let(:default_headers) { { 'Accept' => '*/*', 'Host' => '184.188.80.195' } }
  let(:options) { { username: '123', password: 'abc' } }

  before do
    stub_request(:post, "https://api.lipseys.com/api/integration/authentication/login").
      with(:body => "{\"email\":\"123\",\"password\":\"abc\"}").
      to_return(
        :status => 200, :body => {"token": "Cw2Om8PqL/bZtpTELyDfuTJqAekW5oqhr842jPpcSUA="}.to_json, :headers => {})

    stub_request(:get, "https://api.lipseys.com/api/integration/items/pricingquantityfeed").
      with(body: "{}",).to_return(status: 200, body: FixtureHelper.get_fixture_file('LipseysInventoryPricing.json').read, headers: {})

  end

  describe '.all' do
    it 'returns an array of items' do
      items = Lipseys::Inventory.all(options)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:item_identifier]).to eq('SI365XCA9COMP')
          expect(item[:price]).to eq(697.00)
        when 1
          expect(item[:item_identifier]).to eq('WBMAP01N653WR8B')
          expect(item[:price]).to eq(2165.59)
        end
      end

      expect(items.count).to eq(3)
    end
  end

end
