require "spec_helper"
require "savon/mock/spec_helper"

describe Lipseys::Order do

  include Savon::SpecHelper

  before do
    WebMock.disable!
  end

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  let(:default_headers) { { 'Accept' => '*/*', 'Host' => 'www.lipseys.com' } }
  let(:options) { { username: '123', password: 'abc' } }

  describe '#submit' do
    let(:order) { 
      Lipseys::Order.new(options.merge({
        quantity: 1,
        purchase_order: '1000-2000',
        item_number: 'A000011'
      }))
    }

    let(:fixture) { File.read(File.join(Dir.pwd, 'spec/fixtures/order_response.xml')) }

    before do
      savon.expects(:submit_order).with(message: :any).returns(fixture)
    end

    it 'sends a request to Lipseys API' do
      result = order.submit!
      expect(result[:order_number]).to eq('100')
      expect(result[:new_order]).to eq(true)
      expect(result[:success]).to eq(true)
      expect(result[:description]).to eq('desc')
    end
  end

end
