require 'faraday'
require 'fabricio/authorization/session'

module Fabricio
  module Authorization
    class AuthorizationSigner
      def sign_request(request, session)
        request.headers['Authorization'] = "Bearer #{session.access_token}"
        request
      end
    end
  end
end
