require 'rspec'
require 'webmock/rspec'
require 'fabricio/models/app'
require 'fabricio/authorization/session'

describe 'App' do

  it 'should find all' do
    response_file = File.new(Dir.getwd + '/spec/app_all_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => 'token',
                                                       'refresh_token' => 'token'
                                                   })
    result = Fabricio::App.all(session)
    expect(result.count).to equal(2)
  end

  it 'should find by id' do
    response_file = File.new(Dir.getwd + '/spec/app_find_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => 'token',
                                                       'refresh_token' => 'token'
                                                   })
    result = Fabricio::App.find('test_id', session)
    expect(result).not_to be_nil
  end

  it 'should fetch active_now' do
    response_file = File.new(Dir.getwd + '/spec/app_active_now_stub_response.txt')
    stub_request(:get, /apps/).to_return(:body => response_file, :status => 200)
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => '8aeae4f2bf2d975fbe1d758e41e74228922f40e69fae0ebc552df5f12a30450d',
                                                       'refresh_token' => 'token'
                                                   })
    result = Fabricio::App.active_now('543e4e8e44b34d62fc00006e', '543e4c989254296dcc000cd4', session)
    expect(result).not_to be_nil
  end
end