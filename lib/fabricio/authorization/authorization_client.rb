require 'faraday'
require 'json'
require 'fabricio/authorization/session'
require 'fabricio/authorization/abstract_session_storage'
require 'fabricio/services/organization_service'

AUTH_API_URL = 'https://instant.fabric.io/oauth/token'
ORGANIZATION_API_URL = 'https://fabric.io/api/v2/organizations'

module Fabricio
  module Authorization
    # A class used for user authorization. If there is a cached session, it returns it instead of making network request.
    class AuthorizationClient

      # Initializes a new AuthorizationClient object
      #
      # @param session_storage [Fabricio::Authorization::AbstractSessionStorage]
      # @return [Fabricio::Authorization::AuthorizationClient]
      def initialize(session_storage)
        @session_storage = session_storage
      end

      # Returns a session object for making API requests.
      # Depending on the cache state, it's obtained either via network request to OAuth API or from the local storage.
      #
      # @param username [String]
      # @param password [String]
      # @param client_id [String]
      # @param client_secret [String]
      # @param force [Boolean] Should the client ignore local cache
      # @return [Fabricio::Authorization::Session]
      def auth(username, password, client_id, client_secret, force = false)
        session = @session_storage.obtain_session
        if !session || force
          session = perform_authorization(username, password, client_id, client_secret)
          @session_storage.store_session(session)
        end
        session
      end

      private

      # Initiates two network requests. One for obtaining session (access and refresh tokens).
      # Another one for obtaining organization identifier.
      #
      # @param username [String]
      # @param password [String]
      # @param client_id [String]
      # @param client_secret [String]
      # @return [Fabricio::Authorization::Session]
      def perform_authorization(username, password, client_id, client_secret)
        auth_data = obtain_auth_data(username, password, client_id, client_secret)
        organization_id = obtain_organization_id(auth_data)
        Session.new(auth_data, organization_id)
      end

      # Makes a request to OAuth API and obtains access and refresh tokens.
      #
      # @param username [String]
      # @param password [String]
      # @param client_id [String]
      # @param client_secret [String]
      # @return [Hash]
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

      # Makes a request to fetch current organization identifier.
      # This identifier is used in most other API requests, so we store it in the session.
      #
      # @param auth_data [Hash] A set of authorization tokens
      # @option options [String] :access_token OAuth access token
      # @option options [String] :refresh_token OAuth refresh token
      # @return [String]
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
