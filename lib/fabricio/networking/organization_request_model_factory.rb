require 'fabricio/networking/request_model'
require 'fabricio/authorization/authorization_signer'

module Fabricio
  module Networking
    class OrganizationRequestModelFactory
      include Fabricio::Authorization::AuthorizationSigner

      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_ORGANIZATIONS_ENDPOINT = '/organizations'

      def get_organization_request_model(session)
        model = Fabricio::Networking::RequestModel.new do |model|
          model.type = :GET
          model.base_url = FABRIC_API_URL
          model.api_path = FABRIC_API_PATH + FABRIC_ORGANIZATIONS_ENDPOINT
        end
        sign_request_model(model, session)
        model
      end

    end
  end
end
