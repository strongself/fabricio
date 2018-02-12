require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/version_service'
require 'fabricio/authorization/memory_session_storage'

describe 'VersionService' do

  before(:each) do
    storage = Fabricio::Authorization::MemorySessionStorage.new
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => '123',
                                                       'refresh_token' => '123'
                                                   }, '123')
    storage.store_session(session)
    client = Fabricio::Networking::NetworkClient.new(nil, storage)
    @service = Fabricio::Service::VersionService.new(Fabricio::Authorization::Session.new, client)
  end

  it 'should fetch all versions' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/version_service_all_stub_response.txt')
    stub_request(:get, /versions/).to_return(:body => response_file, :status => 200)

    result = @service.all('1', 1, 1)
    expect(result).not_to be_nil
  end

  it 'should get top versions' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/version_service_top_stub_response.txt')
    stub_request(:get, /top_builds/).to_return(:body => response_file, :status => 200)

    result = @service.top('1', '1', '1')
    expect(result).not_to be_nil
  end

end
