require 'rspec'
require 'webmock/rspec'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/session'

describe 'Authorization Client' do

  TEST_STRING = 'string'
  TEST_TOKEN = 'token'
  TEST_NETWORK_TOKEN = 'network_token'
  TEST_ORGANIZATION_ID = 'org_id'
  TEST_NETWORK_ORGANIZATION_ID = 'network_org_id'

  before(:each) do
    @client = Fabricio::Authorization::AuthorizationClient.new
    @test_session = Fabricio::Authorization::Session.new({
                                                          'access_token' => TEST_TOKEN,
                                                          'refresh_token' => TEST_TOKEN
                                                         }, TEST_ORGANIZATION_ID)
  end

  it 'should return session for successful authorization' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/authorization/authorization_success_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/authorization/organization_stub_response.txt')
    stub_request(:get, /organizations/).to_return(:body => response_file, :status => 200)

    session = @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)

    expect(session.access_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.refresh_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.organization_id).to eq(TEST_NETWORK_ORGANIZATION_ID)
  end

  it 'should throw error on incorrect authorization response' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/authorization/authorization_failure_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 401)

    expect {
      @client.auth(TEST_STRING, TEST_STRING, TEST_STRING, TEST_STRING)
    }.to raise_error(StandardError)
  end

  it 'should return session for successful refresh' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/authorization/authorization_success_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 200)

    session = @client.refresh(@test_session)

    expect(session.access_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.refresh_token).to eq(TEST_NETWORK_TOKEN)
    expect(session.organization_id).to eq(TEST_ORGANIZATION_ID)
  end

  it 'should throw error on incorrect refresh response' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/authorization/authorization_failure_stub_response.txt')
    stub_request(:post, /token/).to_return(:body => response_file, :status => 401)

    expect {
      @client.refresh(@test_session)
    }.to raise_error(StandardError)
  end
end