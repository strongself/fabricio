require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/build_service'

describe 'BuildService' do

  before(:each) do
    @service = Fabricio::Service::BuildService.new(Fabricio::Authorization::Session.new)
  end

  it 'should fetch all builds' do
    response_file = File.new(Dir.getwd + '/spec/service/build_service_all_builds_stub_response.txt')
    stub_request(:get, /releases/).to_return(:body => response_file, :status => 200)

    result = @service.all('1')
    expect(result).not_to be_nil
  end

end