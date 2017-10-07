require 'rspec'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/session'

describe 'Authorization Client' do
  TEST_STRING = 'string'
  TEST_TOKEN = 'token'
  TEST_ORGANIZATION_ID = 'org_id'
  TEST_NETWORK_ORGANIZATION_ID = 'network_org_id'

  before(:each) do
    @client = Fabricio::Authorization::AuthorizationClient.new
    @test_session = @client.auth(
               ENV[TEST_EMAIL_KEY],
               ENV[TEST_PASSWORD_KEY],
               ENV[TEST_CLIENT_ID],
               ENV[TEST_CLIENT_SECRET]
    )
  end

  it 'should return session for successful authorization' do
    expect(@test_session.access_token).not_to be_nil
    expect(@test_session.refresh_token).not_to be_nil
    expect(@test_session.organization_id).not_to be_nil
  end

  it 'should throw error on incorrect authorization response' do
    other_client = Fabricio::Authorization::AuthorizationClient.new

    expect {
      other_client.auth(
          ENV[TEST_EMAIL_KEY],
          'other_pass',
          '2c18f8a77609ee6bbac9e53f3768fedc45fb96be0dbcb41defa706dc57d9c931',
          '092ed1cdde336647b13d44178932cba10911577faf0eda894896188a7d900cc9'
      )
    }.to raise_error(StandardError)
  end

  it 'should return session for successful refresh' do
    session = @client.refresh(@test_session)

    expect(session.access_token).not_to be_nil
    expect(session.refresh_token).not_to be_nil
    expect(session.organization_id).not_to be_nil
  end

  it 'should throw error on incorrect refresh response' do
    wrong_session = Fabricio::Authorization::Session.new({
                                                             'access_token' => TEST_TOKEN,
                                                             'refresh_token' => TEST_TOKEN
                                                         }, TEST_ORGANIZATION_ID)
    expect {
      @client.refresh(wrong_session)
    }.to raise_error(StandardError)
  end
end