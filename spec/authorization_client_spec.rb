require 'rspec'
require 'webmock/rspec'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/session'

describe 'Authorization Client' do

  it 'should return session' do
    response_file = File.new(Dir.getwd + '/spec/authorization_success_stub_response.txt')
    stub_request(:post, 'https://instant.fabric.io/oauth/token').to_return(:body => response_file, :status => 200)

    client = Fabricio::Authorization::AuthorizationClient
    session = client.auth('myemail@email.ru', 'my_pass', '2c18f8a77609ee6bbac9e53f3768fedc45fb96be0dbcb41defa706dc57d9c931', '092ed1cdde336647b13d44178932cba10911577faf0eda894896188a7d900cc9')
    expect(session.access_token).not_to be_nil
    expect(session.refresh_token).not_to be_nil
  end
end