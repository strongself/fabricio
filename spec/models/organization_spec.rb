require 'rspec'
require 'webmock/rspec'
require 'fabricio/models/organization'
require 'fabricio/authorization/session'

describe 'Organization' do

  it 'should find' do
    response_file = File.new(Dir.getwd + '/spec/organization_find_stub_response.txt')
    stub_request(:get, 'https://fabric.io/api/v2/organizations').to_return(:body => response_file, :status => 200)
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => 'token',
                                                       'refresh_token' => 'token'
                                                   })
    result = Fabricio::Organization.find(session)
    expect(result).not_to be_nil
  end
end