require 'rspec'
require_relative 'constants'
require 'fabricio/services/organization_service'
require 'fabricio/authorization/memory_session_storage'

describe 'OrganizationService' do

  before(:each) do
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
    @service = Fabricio::Service::OrganizationService.new(session, client)
  end

  it 'should fetch organization' do
    result = @service.get
    expect(result.id).to eq ENV[TEST_ORGANIZATION_ID]
    expect(result.json).not_to be_nil
  end

end
