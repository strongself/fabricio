require 'rspec'
require 'fabricio/networking/build_request_model_factory'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/session'

describe 'BuildRequestModelFactory' do

  before(:each) do
    @factory = Fabricio::Networking::BuildRequestModelFactory.new
    @session = Fabricio::Authorization::Session.new({
                                                        'access_token' => 'token',
                                                        'refresh_token' => 'token'
                                                    })
  end

  it 'should form all builds request model' do
    result = @factory.all_builds_request_model(@session, '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form get build request model' do
    result = @factory.get_build_request_model(@session, '1', '1', '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
    expect(result.params).not_to be_nil
  end
end