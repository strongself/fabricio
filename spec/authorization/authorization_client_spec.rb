require 'rspec'
require 'webmock/rspec'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/session'
require 'fabricio/authorization/memory_session_storage'

describe 'Authorization Client' do

  TEST_STRING = 'string'
  TEST_TOKEN = 'token'
  TEST_NETWORK_TOKEN = 'network_token'
  TEST_ORGANIZATION_ID = 'org_id'
  TEST_NETWORK_ORGANIZATION_ID = 'network_org_id'

  before(:each) do
    @storage = Fabricio::Authorization::MemorySessionStorage.new
    @client = Fabricio::Authorization::AuthorizationClient.new(@storage)
    @test_session = Fabricio::Authorization::Session.new({
                                                          'access_token' => TEST_TOKEN,
                                                          'refresh_token' => TEST_TOKEN
                                                         }, TEST_ORGANIZATION_ID)
  end

  it 'should return cached session' do
    set_test_cached_session(@test_session)

    result = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)
    expect(result.access_token).to eq(TEST_TOKEN)
    expect(result.refresh_token).to eq(TEST_TOKEN)
    expect(result.organization_id).to eq(TEST_ORGANIZATION_ID)
  end

  it 'should perform auth if no session' do
    response_file = File.new(Dir.getwd + '/spec/authorization/authorization_success_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/authorization/organization_stub_response.txt')
    stub_request(:get, /organizations/).to_return(:body => response_file, :status => 200)

    set_test_cached_session(nil)

    session = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)

    expect(session.access_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.refresh_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.organization_id).to eq(TEST_NETWORK_ORGANIZATION_ID)
  end

  it 'should perform force auth' do
    response_file = File.new(Dir.getwd + '/spec/authorization/authorization_success_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/authorization/organization_stub_response.txt')
    stub_request(:get, /organizations/).to_return(:body => response_file, :status => 200)

    set_test_cached_session(@test_session)

    session = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING, true)

    expect(session.access_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.refresh_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.organization_id).to eq(TEST_NETWORK_ORGANIZATION_ID)
  end

  it 'should cache session after auth' do
    response_file = File.new(Dir.getwd + '/spec/authorization/authorization_success_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/authorization/organization_stub_response.txt')
    stub_request(:get, /organizations/).to_return(:body => response_file, :status => 200)

    set_test_cached_session(nil)

    @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)
    failure_response_file = File.new(Dir.getwd + '/spec/authorization/authorization_failure_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => failure_response_file, :status => 200)
    session = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)

    expect(session.access_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.refresh_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.organization_id).to eq(TEST_NETWORK_ORGANIZATION_ID)
  end

  def set_test_cached_session(session)
    @storage.store_session(session)
  end
end