require 'rspec'
require 'webmock/rspec'
require 'fabricio/cli/cli'
require 'fabricio/cli/app'
require 'fabricio/authorization/file_session_storage'
require 'fabricio/authorization/file_param_storage'
require 'fabricio/authorization/session'

describe 'Cli' do

  let(:cli) { Fabricio::CLI.new }
  subject { cli }

  before(:each) do
    session_storage = Fabricio::Authorization::FileSessionStorage.new()
    session = Fabricio::Authorization::Session.new({
      'access_token' => 'access_token',
      'refresh_token' => 'refresh_token'})
    session_storage.store_session(session)
    param_storage = Fabricio::Authorization::FileParamStorage.new()
    param_storage.store_organization_id('1')
    param_storage.store_app_id('1')
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/organization_service_get_stub_response.txt')
    stub_request(:get, /organizations/).to_return(:body => response_file, :status => 200)
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_all_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)
  end

  after(:all) do
    session_storage = Fabricio::Authorization::FileSessionStorage.new()
    session_storage.reset
    param_storage = Fabricio::Authorization::FileParamStorage.new()
    param_storage.reset
  end

  describe 'App' do
    it 'should fetch all apps' do
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.app 'all' }
      expect(output).not_to be_nil
      first = output[0]
      expect(first).not_to be_nil
      expect(first['id']).to eq('id_1')
    end

    it 'should fetch single app' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_get_stub_response.txt')
      stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.app 'get' }
      expect(output).not_to be_nil
      expect(output['id']).to eq('id_1')
    end

    it 'should fetch active_now' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_active_now_stub_response.txt')
      stub_request(:get, /active_now/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.capture(:stdout) { cli.app 'active_now' }
      expect(output).to eq('31')
    end

    it 'should fetch single issue' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_single_issue_stub_response.txt')
      stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.app 'issue', '1' }
      expect(output).not_to be_nil
      expect(output['title']).to eq('Performer.swift line 0')
    end

    it 'should fetch issue session' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_issue_session_stub_response.txt')
      stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.app 'session', '1', '1' }
      expect(output).not_to be_nil
      expect(output['externalId']).to eq('4dd95e43581247eebaaccffc21965931_DNE_0_v2')
    end

    it 'should fetch latest issue session' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/app_service_issue_session_stub_response.txt')
      stub_request(:post, /graphql/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.app 'latest_session', '1' }
      expect(output).not_to be_nil
      expect(output['externalId']).to eq('4dd95e43581247eebaaccffc21965931_DNE_0_v2')
    end

  end

  describe 'Build' do
    it 'should fetch all builds' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/build_service_all_builds_stub_response.txt')
      stub_request(:get, /releases/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.build 'all'}
      expect(output).not_to be_nil
      first = output[0]
      expect(first).not_to be_nil
      expect(first['id']).to eq('app_id')
    end

    it 'should get build' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/build_service_get_build_stub_response.txt')
      stub_request(:get, /releases/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.build 'get', '1', '1' }
      expect(output).not_to be_nil
      expect(output['id']).to eq('app_id')
    end
  end

  describe 'Organization' do
    it 'should fetch organizations' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/organization_service_get_stub_response.txt')
      stub_request(:get, /organizations/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.organization 'all' }
      expect(output).not_to be_nil
      first = output[0]
      expect(first).not_to be_nil
      expect(first['id']).to eq('org_id')
    end
  end

  describe 'Version' do
    it 'should fetch all versions' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/version_service_all_stub_response.txt')
      stub_request(:get, /versions/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.version 'all' }
      expect(output).not_to be_nil
      first = output[0]
      expect(first).not_to be_nil
      expect(first['id']).to eq(56169171)
    end

    it 'should get top versions' do
      response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/version_service_top_stub_response.txt')
      stub_request(:get, /top_builds/).to_return(:body => response_file, :status => 200)
      output = Helpers::CliExecutor.json_capture(:stdout) { cli.version 'top' }
      expect(output).not_to be_nil
      first = output[0]
      expect(first).to eq('2.0 (1413267064)')
    end
  end

end
