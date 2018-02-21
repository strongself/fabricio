require 'rspec'
require 'fabricio/networking/organization_request_model_factory'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/session'

describe 'OrganizationRequestModelFactory' do

  before(:each) do
    param_storage = Fabricio::Authorization::MemoryParamStorage.new
    param_storage.store_organization_id('1')
    @factory = Fabricio::Networking::OrganizationRequestModelFactory.new(param_storage)
  end

  it 'should form all organization request model' do
    result = @factory.all_organization_request_model

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end
end
