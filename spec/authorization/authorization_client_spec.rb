require 'rspec'
require 'webmock/rspec'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/session'
require 'fabricio/configuration/configuration'
require 'fabricio/authorization/memory_session_storage'

describe 'Authorization Client' do

  TEST_STRING = 'string'
  TEST_TOKEN = 'token'
  TEST_NETWORK_TOKEN = 'network_token'

  before(:each) do
    @client = Fabricio::Authorization::AuthorizationClient.new
    @test_session = Fabricio::Authorization::Session.new({
                                                          'access_token' => TEST_TOKEN,
                                                          'refresh_token' => TEST_TOKEN
                                                         })
  end

  it 'should return cached session' do
    set_test_cached_session(@test_session)

    result = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)
    expect(result.access_token).to eq(TEST_TOKEN)
    expect(result.refresh_token).to eq(TEST_TOKEN)
  end

  it 'should perform auth if no session' do
    response_file = File.new(Dir.getwd + '/spec/authorization/authorization_success_stub_response.txt')
    stub_request(:post, 'https://instant.fabric.io/oauth/token').to_return(:body => response_file, :status => 200)

    set_test_cached_session(nil)

    session = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)

    expect(session.access_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.refresh_token).to eq(TEST_NETWORK_TOKEN)
  end

  it 'should perform force auth' do
    response_file = File.new(Dir.getwd + '/spec/authorization/authorization_success_stub_response.txt')
    stub_request(:post, 'https://instant.fabric.io/oauth/token').to_return(:body => response_file, :status => 200)

    set_test_cached_session(@test_session)

    session = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING, true)

    expect(session.access_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.refresh_token).to eq(TEST_NETWORK_TOKEN)
  end

  it 'should cache session after auth' do
    response_file = File.new(Dir.getwd + '/spec/authorization/authorization_success_stub_response.txt')
    stub_request(:post, 'https://instant.fabric.io/oauth/token').to_return(:body => response_file, :status => 200)

    set_test_cached_session(nil)

    t = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)
    failure_response_file = File.new(Dir.getwd + '/spec/authorization/authorization_failure_stub_response.txt')
    stub_request(:post, 'https://instant.fabric.io/oauth/token').to_return(:body => failure_response_file, :status => 200)
    session = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)

    expect(session.access_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.refresh_token).to eq(TEST_NETWORK_TOKEN)
  end

  def set_test_cached_session(session)
    storage = Fabricio::Authorization::MemorySessionStorage.new
    storage.store_session(session)
    Fabricio.configure do |config|
      config.session_storage = storage
    end
  end
end