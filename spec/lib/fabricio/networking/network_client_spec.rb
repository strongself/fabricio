require 'rspec'
require 'webmock/rspec'
require 'fabricio/networking/network_client'
require 'fabricio/networking/request_model'
require 'fabricio/networking/organization_request_model_factory'
require 'fabricio/authorization/session'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/memory_session_storage'

describe 'NetworkClient' do

  TEST_REFRESHED_TOKEN = '456'

  before(:each) do
    @storage = Fabricio::Authorization::MemorySessionStorage.new
    @authorization_client = Fabricio::Authorization::AuthorizationClient.new
    @client = Fabricio::Networking::NetworkClient.new(@authorization_client, @storage)

    session = Fabricio::Authorization::Session.new({
                                                    'access_token' => TEST_TOKEN,
                                                    'refresh_token' => '123'
                                                   })
    @storage.store_session(session)
  end

  it 'should perform GET request' do
    base_url = 'http://test.ru'
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/networking/network_client_stub_response.txt')
    stub_request(:get, base_url).to_return(:body => response_file, :status => 200)

    model = Fabricio::Networking::RequestModel.new do |config|
      config.type = :GET
      config.base_url = base_url
    end
    result = @client.perform_request(model)

    expect(result).not_to be_nil
  end

  it 'should perform POST request' do
    base_url = 'http://test.ru'
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/networking/network_client_stub_response.txt')
    stub_request(:post, base_url).to_return(:body => response_file, :status => 200)

    model = Fabricio::Networking::RequestModel.new do |config|
      config.type = :POST
      config.base_url = base_url
    end
    result = @client.perform_request(model)

    expect(result).not_to be_nil
  end

  it 'should refresh session on auth error' do
    base_url = 'http://test.ru'
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/networking/authorization_failure_stub_response.txt')
    stub_request(:get, base_url).to_return(:body => response_file, :status => 401).
        with(headers: { 'Authorization' => "Bearer #{TEST_TOKEN}" })
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/networking/authorization_success_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/networking/network_client_stub_response.txt')
    stub_request(:get, base_url).to_return(:body => response_file, :status => 200).
        with(headers: { 'Authorization' => "Bearer #{TEST_REFRESHED_TOKEN}" })

    model = Fabricio::Networking::RequestModel.new do |config|
      config.type = :GET
      config.base_url = base_url
    end
    result = @client.perform_request(model)

    expect(result).not_to be_nil
  end

  it 'should throw exception after refresh session error' do
    base_url = 'http://test.ru'
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/networking/authorization_failure_stub_response.txt')
    stub_request(:get, base_url).to_return(:body => response_file, :status => 401)
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/networking/authorization_success_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 200)

    model = Fabricio::Networking::RequestModel.new do |config|
      config.type = :GET
      config.base_url = base_url
    end
    expect {
      @client.perform_request(model)
    }.to raise_error(StandardError)

  end
end