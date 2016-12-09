require 'rspec'
require 'fabricio/networking/network_client'
require 'fabricio/networking/organization_request_model_factory'
require 'fabricio/authorization/session'

describe 'NetworkClient' do

  it 'should perform GET requests' do
    factory = Fabricio::Networking::OrganizationRequestModelFactory.new

    session = Fabricio::Authorization::Session.new({
                                                      'access_token' => '16fda57c468db8d50dbbc31bf4c0c2857ea3d8e33213d9356e35fd424232c3f0',
                                                      'refresh_token' => '2a9330889980f6f774ee9deec68ddd8903e18c3e016fd3b4ffe1447e9cb610c5'
                                                  })

    model = factory.get_organization_request_model(session)
    client = Fabricio::Networking::NetworkClient.new
    response = client.perform_request(model)
    true.should == false
  end
end