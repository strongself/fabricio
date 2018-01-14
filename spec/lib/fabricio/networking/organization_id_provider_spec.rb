require 'rspec'
require 'fabricio/networking/organization_id_provider'
require 'fabricio/models/app'

describe 'OrganizationIdProvider' do

  SAMPLE_ORGANIZATION_ID = '2'

  before(:each) do
    @sample_app = Fabricio::Model::App.new({
      'organization_id' => SAMPLE_ORGANIZATION_ID,
      'id' => '1'
    })
    @app_list_provider = spy("App list provider", :call => [@sample_app])
    @organization_id_provider = Fabricio::Networking::OrganizationIdProvider.new(@app_list_provider)
  end

  it 'should not obtain app list automatically' do
    expect(@app_list_provider).to_not have_received(:call)
  end

  it 'should obtain app list once on demand' do
    @organization_id_provider.get("1")
    @organization_id_provider.get("1")
    
    expect(@app_list_provider).to have_received(:call).once
  end

  it 'should return the correct organization id' do
    organization_id = @organization_id_provider.get("1")
    
    expect(organization_id).to eq SAMPLE_ORGANIZATION_ID
  end
end
