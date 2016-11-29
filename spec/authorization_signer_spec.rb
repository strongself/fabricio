require 'rspec'
require 'faraday'
require 'fabricio/authorization/authorization_signer'
require 'fabricio/authorization/session'

describe 'Authorization Signer' do

  before(:each) do
    @signer = Fabricio::Authorization::AuthorizationSigner.new
  end

  it 'should sign request with access token' do
    access_token = 'access_token'
    refresh_token = 'access_token'
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => access_token,
                                                       'refresh_token' => refresh_token
                                                   })
    conn = Faraday.new(:url => 'http://test.com')
    conn.get do |request|
      @signer.sign_request(request, session)
      expect(request.headers['Authorization']).to include(access_token)
    end

  end
end