require 'rspec'
require 'fabricio/authorization/authorization_signer'
require 'fabricio/authorization/session'
require 'fabricio/request_factories/request_model'

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
    model = Fabricio::Networking::RequestModel.new
    @signer.sign_request_model(model, session)
    expect(model.headers['Authorization']).to include(access_token)

  end
end