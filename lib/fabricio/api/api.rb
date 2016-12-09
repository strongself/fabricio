require 'fabricio/models/organization'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/session'
require 'fabricio/networking/organization_request_model_factory'

module Fabricio
  module Api
    @auth_client = Fabricio::Authorization::AuthorizationClient.new

    class << self

      def organization
        session = obtain_session
        Fabricio::Organization.find(session)
      end

      private

      def obtain_session
        @auth_client.auth(Fabricio.username,
                          Fabricio.password,
                          Fabricio.client_id,
                          Fabricio.client_secret)
      end
    end
  end
end