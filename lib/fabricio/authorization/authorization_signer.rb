require 'faraday'
require 'fabricio/authorization/session'
require 'fabricio/networking/request_model'

module Fabricio
  module Authorization
    module AuthorizationSigner
      def sign_request_model(request_model, session)
        request_model.headers['Authorization'] = "Bearer #{session.access_token}"
        request_model
      end
    end
  end
end
