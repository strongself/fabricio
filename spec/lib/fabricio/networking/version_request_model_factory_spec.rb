require 'rspec'
require 'fabricio/networking/version_request_model_factory'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/session'

describe 'VersionRequestModelFactory' do

  before(:each) do
    param_storage = Fabricio::Authorization::MemoryParamStorage.new
    param_storage.store_organization_id('1')
    @factory = Fabricio::Networking::VersionRequestModelFactory.new(param_storage)
  end

  it 'should form all version request model' do
    result = @factory.all_versions_request_model('1', 1, 1)

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form top versions request model' do
    result = @factory.top_versions_request_model(nil, '1', '1', '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
    expect(result.params).not_to be_nil
  end
end
