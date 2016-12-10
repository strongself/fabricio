require 'fabricio/networking/organization_request_model_factory'
require 'fabricio/networking/network_client'
require 'fabricio/models/organization'

module Fabricio
  module Service
    class OrganizationService

      def initialize(session)
        @session = session

        @request_model_factory = Fabricio::Networking::OrganizationRequestModelFactory.new
        @network_client = Fabricio::Networking::NetworkClient.new
      end

      def get
        request_model = @request_model_factory.get_organization_request_model(@session)
        response = @network_client.perform_request(request_model)
        Fabricio::Model::Organization.new(JSON.parse(response.body)[0])
      end
    end
  end
end
