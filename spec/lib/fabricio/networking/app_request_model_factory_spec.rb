require 'rspec'
require 'fabricio/networking/app_request_model_factory'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/session'

describe 'AppRequestModelFactory' do

  before(:each) do
    @factory = Fabricio::Networking::AppRequestModelFactory.new
    @session = Fabricio::Authorization::Session.new({
                                                       'access_token' => 'token',
                                                       'refresh_token' => 'token'
                                                   })
  end

  it 'should form all apps request model' do
    result = @factory.all_apps_request_model

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form get app request model' do
    result = @factory.get_app_request_model('1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form active_now app request model' do
    result = @factory.active_now_request_model(@session, '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form daily_new app request model' do
    result = @factory.daily_new_request_model(@session, '1', '1', '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form daily_active app request model' do
    result = @factory.daily_active_request_model(@session, '1', '1', '1', '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form monthly_active app request model' do
    result = @factory.monthly_active_request_model(@session, '1', '1', '1', '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form session_count app request model' do
    result = @factory.total_sessions_request_model(@session, '1', '1', '1', '1')

    expect(result.type).to eq :GET
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form crashes app request model' do
    result = @factory.crash_count_request_model('1', '1', '1', ['1', '2'])

    expect(result.type).to eq :POST
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form top issues request model' do
    result = @factory.top_issues_request_model('1', 1, 1, ['1', '2'], 10)

    expect(result.type).to eq :POST
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form single issue request model' do
    result = @factory.single_issue_request_model('1', '1', 1, 1)

    expect(result.type).to eq :POST
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form issue session request model' do
    result = @factory.issue_session_request_model('1', '1', '1')

    expect(result.type).to eq :POST
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form add comment request model' do
    result = @factory.add_comment_request_model('1', '1', '1')

    expect(result.type).to eq :POST
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end

  it 'should form oomfree app request model' do
    result = @factory.oom_count_request_model('1', 30, ['1', '2'])

    expect(result.type).to eq :POST
    expect(result.base_url).not_to be_nil
    expect(result.api_path).not_to be_nil
    expect(result.headers).not_to be_nil
  end
end
