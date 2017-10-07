require 'rspec'
require 'fabricio/services/app_service'
require 'fabricio/networking/network_client'
require 'fabricio/authorization/memory_session_storage'

describe 'AppService' do

  before(:each) do
    auth_client = Fabricio::Authorization::AuthorizationClient.new
    session = auth_client.auth(
        ENV[TEST_EMAIL_KEY],
        ENV[TEST_PASSWORD_KEY],
        ENV[TEST_CLIENT_ID],
        ENV[TEST_CLIENT_SECRET]
    )
    storage = Fabricio::Authorization::MemorySessionStorage.new
    storage.store_session(session)
    client = Fabricio::Networking::NetworkClient.new(nil, storage)
    @service = Fabricio::Service::AppService.new(Fabricio::Authorization::Session.new, client)
  end

  it 'should fetch all apps' do
    result = @service.all
    expect(result).not_to be_nil
  end

  it 'should fetch single app' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_get_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)

    result = @service.get('1')
    expect(result).not_to be_nil
  end

  it 'should fetch active_now' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_active_now_stub_response.txt')
    stub_request(:get, /active_now/).to_return(:body => response_file, :status => 200)

    result = @service.active_now('1')
    expect(result).not_to be_nil
  end

  it 'should fetch daily_new' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_daily_new_stub_response.txt')
    stub_request(:get, /daily_new/).to_return(:body => response_file, :status => 200)

    result = @service.daily_new('1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch daily_active' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_daily_active_stub_response.txt')
    stub_request(:get, /daily_active/).to_return(:body => response_file, :status => 200)

    result = @service.daily_active('1', '1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch weekly_active' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_daily_active_stub_response.txt')
    stub_request(:get, /weekly_active/).to_return(:body => response_file, :status => 200)

    result = @service.weekly_active('1', '1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch monthly_active' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_daily_active_stub_response.txt')
    stub_request(:get, /monthly_active/).to_return(:body => response_file, :status => 200)

    result = @service.monthly_active('1', '1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch total_sessions' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_total_sessions_stub_response.txt')
    stub_request(:get, /total_sessions/).to_return(:body => response_file, :status => 200)

    result = @service.total_sessions('1', '1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch crashes' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_crashes_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.crashes('1', '1', '1', ['1'])
    expect(result).not_to be_nil
  end

  it 'should fetch crashfree' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_crashes_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_total_sessions_stub_response.txt')
    stub_request(:get, /total_sessions/).to_return(:body => response_file, :status => 200)

    result = @service.crashfree('1', '1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch top issues' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_top_issues_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.top_issues('1', 1, 1, ['1'], 1)
    expect(result).not_to be_nil
  end

  it 'should fetch single issue' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_single_issue_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.single_issue('1', '1', 1, 1)
    expect(result).not_to be_nil
  end

  it 'should fetch issue session' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_issue_session_stub_response.txt')
    stub_request(:get, /sessions/).to_return(:body => response_file, :status => 200)

    result = @service.issue_session('1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch add comment result' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_add_comment_stub_response.txt')
    stub_request(:post, /notes/).to_return(:body => response_file, :status => 200)

    result = @service.add_comment('1', '1', '1')
    expect(result).not_to be_nil
  end

  it 'should fetch oomfree' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_oomfree_stub_response.txt')
    stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)

    result = @service.oomfree('1', '1', '1', ['1'])
    expect(result).not_to be_nil
  end

end
