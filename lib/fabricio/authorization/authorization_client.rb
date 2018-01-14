require 'faraday'
require 'json'
require 'fabricio/authorization/session'
require 'fabricio/services/organization_service'

AUTH_API_URL = 'https://fabric.io/oauth/token'

module Fabricio
  module Authorization
    # A class used for user authorization.
    class AuthorizationClient

      # Returns a session object for making API requests.
      #
      # @param username [String]
      # @param password [String]
      # @param client_id [String]
      # @param client_secret [String]
      # @return [Fabricio::Authorization::Session]
      def auth(username, password, client_id, client_secret)
        perform_authorization(username, password, client_id, client_secret)
      end

      # Refreshes an expired session using refresh_token
      #
      # @param session [Fabricio::Authorization::Session] Expired session
      # @return [Fabricio::Authorization::Session]
      def refresh(session)
        perform_refresh_token_request(session)
      end

      private

      # Initiates two network requests. One for obtaining session (access and refresh tokens).
      # Another one for obtaining organization identifier.
      #
      # @param username [String]
      # @param password [String]
      # @param client_id [String]
      # @param client_secret [String]
      # @raise [StandardError] Raises error if server sends incorrect response
      # @return [Fabricio::Authorization::Session]
      def perform_authorization(username, password, client_id, client_secret)
        auth_data = obtain_auth_data(username, password, client_id, client_secret)
        if auth_data['access_token'] == nil
          raise StandardError.new("Incorrect authorization response: #{auth_data}")
        end
        Session.new(auth_data)
      end

      # Initiates a session refresh network request
      #
      # @param session [Fabricio::Authorization::Session] Expired session
      # @raise [StandardError] Raises error if server sends incorrect response
      # @return [Fabricio::Authorization::Session]
      def perform_refresh_token_request(session)
        conn = Faraday.new(:url => AUTH_API_URL) do |faraday|
          faraday.adapter Faraday.default_adapter
        end

        response = conn.post do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = {
              'grant_type' => 'refresh_token',
              'refresh_token' => session.refresh_token
          }.to_json
        end
        result = JSON.parse(response.body)
        if result['access_token'] == nil
          raise StandardError.new("Incorrect authorization response: #{auth_data}")
        end
        Session.new(result)
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
    end
  end
end
