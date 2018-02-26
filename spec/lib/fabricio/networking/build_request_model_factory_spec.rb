require 'rspec'
require 'fabricio/networking/build_request_model_factory'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/session'

describe 'BuildRequestModelFactory' do

  before(:each) do
    param_storage = Fabricio::Authorization::MemoryParamStorage.new
    param_storage.store_organization_id('1')
    param_storage.store_app_id('1')
    @factory = Fabricio::Networking::BuildRequestModelFactory.new(param_storage)
  end

  it 'should form all builds request model' do
    result = @factory.all_builds_request_model

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form get build request model' do
    result = @factory.get_build_request_model(version: '1', build_number: '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
    expect(result.params).not_to be_nil
  end

end
