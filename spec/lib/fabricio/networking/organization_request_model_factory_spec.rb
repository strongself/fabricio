require 'rspec'
require 'fabricio/networking/organization_request_model_factory'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/session'

describe 'OrganizationRequestModelFactory' do

  before(:each) do
    @factory = Fabricio::Networking::OrganizationRequestModelFactory.new
  end

  it 'should form get organization request model' do
    result = @factory.get_organization_request_model

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end
end