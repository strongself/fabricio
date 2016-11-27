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
end