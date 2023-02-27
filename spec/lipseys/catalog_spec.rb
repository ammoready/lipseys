require "spec_helper"

describe Lipseys::Catalog do

  let(:default_headers) { { 'Accept' => '*/*', 'Host' => '184.188.80.195' } }
  let(:options) { { username: '123', password: 'abc' } }

  before do
    stub_request(:post, "https://api.lipseys.com/api/integration/authentication/login").
      with(:body => "{\"email\":\"123\",\"password\":\"abc\"}").
      to_return(
        :status => 200, :body => {"token": "Cw2Om8PqL/bZtpTELyDfuTJqAekW5oqhr842jPpcSUA="}.to_json, :headers => {})

    stub_request(:get, "https://api.lipseys.com/api/integration/items/catalogfeed").
      with(body: "{}",).to_return(status: 200, body: FixtureHelper.get_fixture_file('LipseysCatalog.json').read, headers: {})
  end

  describe '.all' do
    it 'returns an array of all items' do
      items = Lipseys::Catalog.all(options)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:upc]).to eq('798681669981')
          expect(item[:name]).to eq('P365 X-MACRO COMP 365XCA-9-COMP')
        when 1
          expect(item[:upc]).to eq('696528087373')
          expect(item[:name]).to eq('Modern Precision Rifle 801-03024-00')
        end
      end

      expect(items.count).to eq(3)
    end
  end

end
