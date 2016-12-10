require 'faraday'
require 'json'
require 'fabricio/authorization/session'
require 'fabricio/authorization/abstract_session_storage'

AUTH_API_URL = 'https://instant.fabric.io/oauth/token'

module Fabricio
  module Authorization
    class AuthorizationClient

      def initialize(session_storage)
        @session_storage = session_storage
      end

      def auth(username, password, client_id, client_secret, force = false)
        session = @session_storage.obtain_session
        if !session || force
          session = perform_authorization(username, password, client_id, client_secret)
          @session_storage.store_session(session)
        end
        session
      end

      private

      def perform_authorization(username, password, client_id, client_secret)
        conn = Faraday.new(:url => AUTH_API_URL) do |faraday|
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter Faraday.default_adapter  # make requests with Net::HTTP
        end

        response = conn.post do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = {
              'grant_type' => 'password',
              'scope' => 'organizations apps issues features account twitter_client_apps beta software answers',
              'username' => username,
              'password' => password,
              'client_id' => client_id,
              'client_secret' => client_secret
          }.to_json
        end

        Session.new(JSON.parse(response.body))
      end
    end
  end
end
