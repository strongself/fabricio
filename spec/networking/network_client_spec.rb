require 'rspec'
require 'webmock/rspec'
require 'fabricio/networking/network_client'
require 'fabricio/networking/request_model'
require 'fabricio/networking/organization_request_model_factory'
require 'fabricio/authorization/session'

describe 'NetworkClient' do

  before(:each) do
    @client = Fabricio::Networking::NetworkClient.new
  end

  it 'should perform GET request' do
    base_url = 'http://test.ru'
    response_file = File.new(Dir.getwd + '/spec/networking/network_client_stub_response.txt')
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
    response_file = File.new(Dir.getwd + '/spec/networking/network_client_stub_response.txt')
    stub_request(:post, base_url).to_return(:body => response_file, :status => 200)

    model = Fabricio::Networking::RequestModel.new do |config|
      config.type = :POST
      config.base_url = base_url
    end
    result = @client.perform_request(model)

    expect(result).not_to be_nil
  end
end