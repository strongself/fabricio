require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/app_service'
require 'fabricio/networking/network_client'
require 'fabricio/authorization/memory_session_storage'

describe 'AppService' do

  before(:each) do
    storage = Fabricio::Authorization::MemorySessionStorage.new
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => '123',
                                                       'refresh_token' => '123'
                                                   }, '123')
    storage.store_session(session)
    client = Fabricio::Networking::NetworkClient.new(nil, storage)
    @service = Fabricio::Service::AppService.new(Fabricio::Authorization::Session.new, client)
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

  it 'should fetch daily_active' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_daily_active_stub_response.txt')
    stub_request(:get, /daily_active/).to_return(:body => response_file, :status => 200)

    result = @service.daily_active('1', '1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch total_sessions`' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_total_sessions_stub_response.txt')
    stub_request(:get, /total_sessions/).to_return(:body => response_file, :status => 200)

    result = @service.total_sessions('1', '1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch crashes`' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_crashes_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.crashes('1', '1', '1', ['1'])
    expect(result).not_to be_nil
  end

  it 'should fetch crashfree`' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_crashes_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/service/app_service_total_sessions_stub_response.txt')
    stub_request(:get, /total_sessions/).to_return(:body => response_file, :status => 200)

    result = @service.crashfree('1', '1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch oomfree`' do
    response_file = File.new(Dir.getwd + '/spec/service/app_service_oomfree_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.oomfree('1', '1', '1', ['1'])
    expect(result).not_to be_nil
  end

end