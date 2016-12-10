require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/app_service'

describe 'AppService' do

  before(:each) do
    @service = Fabricio::Service::AppService.new(Fabricio::Authorization::Session.new)
  end

  it 'should fetch all apps' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_all_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)

    result = @service.all
    expect(result).not_to be_nil
  end

  it 'should fetch single app' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_get_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)

    result = @service.get('1')
    expect(result).not_to be_nil
  end

  it 'should fetch active_now' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_active_now_stub_response.txt')
    stub_request(:get, /active_now/).to_return(:body => response_file, :status => 200)

    result = @service.active_now('1')
    expect(result).not_to be_nil
  end

  it 'should fetch daily_new' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_daily_new_stub_response.txt')
    stub_request(:get, /daily_new/).to_return(:body => response_file, :status => 200)

    result = @service.daily_new('1', '1', '1')
    expect(result).not_to be_nil
  end

end