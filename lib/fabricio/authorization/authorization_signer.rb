require 'faraday'
require 'fabricio/authorization/session'
require 'fabricio/networking/request_model'

module Fabricio
  module Authorization
    module AuthorizationSigner
      # Takes a request model and adds 'Authorization' header to it.
      #
      # @param request_model [Fabricio::Networking::RequestModel]
      # @param session [Fabricio::Authorization::Session]
      def sign_request_model(request_model, session)
        request_model.headers['Authorization'] = "Bearer #{session.access_token}"
        request_model
      end
      module_function :sign_request_model
    end
  end
end
