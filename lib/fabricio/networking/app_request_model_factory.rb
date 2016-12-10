require 'fabricio/networking/request_model'
require 'fabricio/authorization/authorization_signer'

module Fabricio
  module Networking
    class AppRequestModelFactory
      include Fabricio::Authorization::AuthorizationSigner

      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_INSTANT_API_URL = 'https://instant.fabric.io'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_APPS_ENDPOINT = '/apps'

      def all_apps_request_model(session)
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_API_URL,
                                                       FABRIC_API_PATH + FABRIC_APPS_ENDPOINT)
        sign_request_model(model, session)
        model
      end

      def get_app_request_model(session, id)
        path = "#{FABRIC_API_PATH}#{FABRIC_APPS_ENDPOINT}/#{id}"
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_API_URL,
                                                       path)
        sign_request_model(model, session)
        model
      end
    end
  end
end
