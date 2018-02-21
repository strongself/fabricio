require 'fabricio/networking/organization_request_model_factory'
require 'fabricio/networking/network_client'
require 'fabricio/models/organization'

module Fabricio
  module Service
    # Service responsible for fetching different Organization information
    class OrganizationService

      # Initializes a new OrganizationService object.
      #
      # @param param_storage [Fabricio::Authorization::AbstractParamStorage]
      # @param network_client [Fabricio::Networking::NetworkClient]
      # @return [Fabricio::Service::OrganizationService]
      def initialize(param_storage, network_client)
        @request_model_factory = Fabricio::Networking::OrganizationRequestModelFactory.new(param_storage)
        @network_client = network_client
      end

      # Obtains all organizations
      #
      # @return [Fabricio::Model::Organization]
      def all
        request_model = @request_model_factory.all_organization_request_model
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body).map do |organization_json|
          Fabricio::Model::Organization.new(organization_json)
        end
      end
    end
  end
end
