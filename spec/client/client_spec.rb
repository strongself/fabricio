require 'rspec'
require 'fabricio/configuration/configuration'
require 'fabricio/client/client'

describe 'Client' do

  it 'should be configurable' do
    test_id = '123'
    client = Fabricio::Client.new
    client.configure do |config|
      config.client_id = test_id
    end

    expect(client.client_id).to eq test_id
  end

end