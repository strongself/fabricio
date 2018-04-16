require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/app_service'
require 'fabricio/networking/network_client'
require 'fabricio/authorization/memory_session_storage'
require 'fabricio/authorization/memory_param_storage'

describe 'AppService' do

  before(:each) do
    storage = Fabricio::Authorization::MemorySessionStorage.new
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => '123',
                                                       'refresh_token' => '123'
                                                   })
    storage.store_session(session)
    client = Fabricio::Networking::NetworkClient.new(nil, storage)
    param_storage = Fabricio::Authorization::MemoryParamStorage.new
    param_storage.store_organization_id('1')
    param_storage.store_app_id('1')
    @service = Fabricio::Service::AppService.new(param_storage, client)
  end

  it 'should fetch all apps' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_all_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)

    result = @service.all
    expect(result).not_to be_nil
  end

  it 'should fetch single app' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_get_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)

    result = @service.get({})
    expect(result).not_to be_nil
  end

  it 'should fetch active_now' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_active_now_stub_response.txt')
    stub_request(:get, /active_now/).to_return(:body => response_file, :status => 200)

    result = @service.active_now({})
    expect(result).not_to be_nil
  end

  it 'should fetch daily_new' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_daily_new_stub_response.txt')
    stub_request(:get, /daily_new/).to_return(:body => response_file, :status => 200)

    result = @service.daily_new({})
    expect(result).not_to be_nil
  end

  it 'should fetch daily_active' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_daily_active_stub_response.txt')
    stub_request(:get, /daily_active/).to_return(:body => response_file, :status => 200)

    result = @service.daily_active(build: '1')
    expect(result).not_to be_nil
  end

  it 'should fetch weekly_active' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_daily_active_stub_response.txt')
    stub_request(:get, /weekly_active/).to_return(:body => response_file, :status => 200)

    result = @service.weekly_active(build: '1')
    expect(result).not_to be_nil
  end

  it 'should fetch monthly_active' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_daily_active_stub_response.txt')
    stub_request(:get, /monthly_active/).to_return(:body => response_file, :status => 200)

    result = @service.monthly_active(build: '1')
    expect(result).not_to be_nil
  end

  it 'should fetch total_sessions' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_total_sessions_stub_response.txt')
    stub_request(:get, /total_sessions/).to_return(:body => response_file, :status => 200)

    result = @service.total_sessions(build: '1')
    expect(result).not_to be_nil
  end

  it 'should fetch crashes' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_crashes_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.crashes({})
    expect(result).not_to be_nil
  end

  it 'should fetch crashfree' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_crashes_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_total_sessions_stub_response.txt')
    stub_request(:get, /total_sessions/).to_return(:body => response_file, :status => 200)

    result = @service.crashfree(build: '1')
    expect(result).not_to be_nil
  end

  it 'should fetch top issues' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_top_issues_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.top_issues({})
    expect(result).not_to be_nil
  end

  it 'should fetch single issue' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_single_issue_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.single_issue(issue_id: '1')
    expect(result).not_to be_nil
  end

  it 'should fetch issue session' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_issue_session_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.issue_session(issue_id: '1')
    expect(result).not_to be_nil
  end

  it 'should fetch add comment result' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_add_comment_stub_response.txt')
    stub_request(:post, /notes/).to_return(:body => response_file, :status => 200)

    result = @service.add_comment(issue_id: '1')
    expect(result).not_to be_nil
  end

  it 'should fetch oomfree' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_oomfree_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.oomfree({})
    expect(result).not_to be_nil
  end

  it 'should fetch all custom events' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_all_custom_events_stub_response.txt')
    stub_request(:get, /event_types_with_data/).to_return(:body => response_file, :status => 200)

    result = @service.all_custom_events({})
    expect(result).not_to be_nil
  end

  it 'should fetch custom event total' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_custom_event_total_stub_response.txt')
    stub_request(:get, /ce_total_events/).to_return(:body => response_file, :status => 200)

    result = @service.custom_event_total(event_type: 'Custom Event Name 1')
    expect(result).not_to be_nil
  end

  it 'should fetch custom event unique devices' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_custom_event_unique_devices_stub_response.txt')
    stub_request(:get, /ce_unique_devices/).to_return(:body => response_file, :status => 200)

    result = @service.custom_event_unique_devices(event_type: 'Custom Event Name 1')
    expect(result).not_to be_nil
  end

  it 'should fetch all custom event attribute' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_all_custom_event_attribute_stub_response.txt')
    stub_request(:get, /ce_attribute_metadata/).to_return(:body => response_file, :status => 200)

    result = @service.all_custom_event_attribute(event_type: 'Custom Event Name 1')
    expect(result).not_to be_nil
  end

  it 'should fetch custom event attribute' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_custom_event_attribute_stub_response.txt')
    stub_request(:get, /ce_category_attribute_data/).to_return(:body => response_file, :status => 200)

    result = @service.custom_event_attribute(event_type: 'Custom Event Name 1', event_attribute: 'Custom Attribute Name 1', selected_time: 1523759011)
    expect(result).not_to be_nil
  end

end
