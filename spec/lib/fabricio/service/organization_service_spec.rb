require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/organization_service'
require 'fabricio/authorization/memory_session_storage'

describe 'OrganizationService' do

  before(:each) do
    storage = Fabricio::Authorization::MemorySessionStorage.new
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => '123',
                                                       'refresh_token' => '123'
                                                   })
    storage.store_session(session)
    client = Fabricio::Networking::NetworkClient.new(nil, storage)
    @service = Fabricio::Service::OrganizationService.new(client)
  end

  it 'should fetch organization' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/organization_service_get_stub_response.txt')
    stub_request(:get, /organizations/).to_return(:body => response_file, :status => 200)

    result = @service.get
    expect(result).not_to be_nil
  end

end
