require 'rspec'
require 'fabricio/client/client'
require 'fabricio/authorization/memory_session_storage'
require 'fabricio/authorization/session'

describe 'Client' do

  before(:each) do
    @storage = Fabricio::Authorization::MemorySessionStorage.new
    @storage.store_session(Fabricio::Authorization::Session.new({}))
  end

  it 'should be configurable' do
    test_id = '123'
    client = Fabricio::Client.new do |config|
      config.client_id = test_id
      config.session_storage = @storage
    end

    expect(client.client_id).to eq test_id
  end

  it 'should return existing service' do
    client = Fabricio::Client.new do |config|
      config.session_storage = @storage
    end
    service = client.organization
    expect(service).not_to be_nil
  end

  it 'should throw exception for non-existing service' do
    client = Fabricio::Client.new do |config|
      config.session_storage = @storage
    end

    expect {
      client.rambler
    }.to raise_error(NoMethodError)
  end
end