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

  it 'should get build' do
    response_file = File.new(Dir.getwd + '/spec/service/build_service_get_build_stub_response.txt')
    stub_request(:get, /releases/).to_return(:body => response_file, :status => 200)

    result = @service.get('1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should get top build versions' do
    response_file = File.new(Dir.getwd + '/spec/service/build_service_top_versions_stub_response.txt')
    stub_request(:get, /top_builds/).to_return(:body => response_file, :status => 200)

    result = @service.top_versions('1', '1', '1')
    expect(result).not_to be_nil
  end

end