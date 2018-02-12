require 'rspec'
require 'fabricio/networking/build_request_model_factory'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/session'

describe 'BuildRequestModelFactory' do

  before(:each) do
    @organization_id_provider = instance_double("OrganizationIdProvider", :get => '1')
    @factory = Fabricio::Networking::BuildRequestModelFactory.new(@organization_id_provider)
  end

  it 'should form all builds request model' do
    result = @factory.all_builds_request_model('1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form get build request model' do
    result = @factory.get_build_request_model('1', '1', '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
    expect(result.params).not_to be_nil
  end

  it 'should form top versions request model' do
    result = @factory.top_versions_request_model('1', '1', '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
    expect(result.params).not_to be_nil
  end
end
