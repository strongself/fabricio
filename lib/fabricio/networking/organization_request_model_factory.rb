require 'fabricio/networking/request_model_factory'
require 'fabricio/networking/request_model'

module Fabricio
  module Networking
    # This factory creates request models for fetching data for Organization model object
    class OrganizationRequestModelFactory < RequestModelFactory

      # Returns a request model for obtaining the organization data
      #
      # @return [Fabricio::Networking::RequestModel]
      def get_organization_request_model
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
