require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/organization_service'

describe 'OrganizationService' do

  before(:each) do
    @service = Fabricio::Service::OrganizationService.new(Fabricio::Authorization::Session.new)
  end

  it 'should fetch organization' do
    response_file = File.new(Dir.getwd + '/spec/service/organization_service_get_stub_response.txt')
    stub_request(:get, /organizations/).to_return(:body => response_file, :status => 200)

    result = @service.get
    expect(result).not_to be_nil
  end

end