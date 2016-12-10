require 'faraday'
require 'json'
require 'fabricio/authorization/session'
require 'fabricio/authorization/abstract_session_storage'
require 'fabricio/services/organization_service'

AUTH_API_URL = 'https://instant.fabric.io/oauth/token'
ORGANIZATION_API_URL = 'https://fabric.io/api/v2/organizations'

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
        auth_data = obtain_auth_data(username, password, client_id, client_secret)
        organization_id = obtain_organization_id(auth_data)
        Session.new(auth_data, organization_id)
      end

      def obtain_auth_data(username, password, client_id, client_secret)
        conn = Faraday.new(:url => AUTH_API_URL) do |faraday|
          faraday.adapter Faraday.default_adapter
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
        JSON.parse(response.body)
      end

      def obtain_organization_id(auth_data)
        conn = Faraday.new(:url => ORGANIZATION_API_URL) do |faraday|
          faraday.adapter Faraday.default_adapter
        end

        response = conn.get do |req|
          req.headers['Authorization'] = "Bearer #{auth_data['access_token']}"
        end
        JSON.parse(response.body).first['id']
      end
    end
  end
end
