require 'rspec'
require_relative 'constants'
require 'date'
require 'fabricio/services/build_service'
require 'fabricio/authorization/memory_session_storage'

describe 'BuildService' do

  before(:each) do
    APP_ID = '59d8b3c4a25bb84434f94105'
    auth_client = Fabricio::Authorization::AuthorizationClient.new
    session = auth_client.auth(
        ENV[TEST_EMAIL_KEY],
        ENV[TEST_PASSWORD_KEY],
        ENV[TEST_CLIENT_ID],
        ENV[TEST_CLIENT_SECRET]
    )
    storage = Fabricio::Authorization::MemorySessionStorage.new
    storage.store_session(session)
    client = Fabricio::Networking::NetworkClient.new(nil, storage)
    @service = Fabricio::Service::BuildService.new(session, client)
  end

  it 'should fetch all builds' do
    result = @service.all(APP_ID)
    expect(result).not_to be_nil
  end

  it 'should get build' do
    result = @service.get(APP_ID, '1.0', '4')
    expect(result).not_to be_nil
  end

  it 'should get top build versions' do
    end_timestamp = Date.today
    start_timestamp = (end_timestamp - 90)
    result = @service.top_versions(APP_ID, 1507383664, 1507383664)
    expect(result.first).to eq "1.0 (4)"
  end

end
