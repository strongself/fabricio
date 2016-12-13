require 'fabricio/networking/request_model'

module Fabricio
  module Networking
    # This factory creates request models for fetching data for Organization model object
    class OrganizationRequestModelFactory

      # Server constants
      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_ORGANIZATIONS_ENDPOINT = '/organizations'

      # Returns a request model for obtaining the organization data
      #
      # @param session [Fabricio::Authorization::Session]
      # @return [Fabricio::Networking::RequestModel]
      def get_organization_request_model(session)
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = FABRIC_API_PATH + FABRIC_ORGANIZATIONS_ENDPOINT
        end
        model
      end

    end
  end
end
