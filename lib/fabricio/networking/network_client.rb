require 'faraday'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/abstract_session_storage'

module Fabricio
  module Networking
    # This class makes network requests based on request models
    class NetworkClient

      # Initializes a new NetworkClient object
      #
      # @param authorization_client [Fabricio::Authorization::AuthorizationClient]
      # @param session_storage [Fabricio::Authorization::AbstractSessionStorage]
      # @return [Fabricio::Networking::NetworkClient]
      def initialize(authorization_client = nil, session_storage = nil)
        @authorization_client = authorization_client
        @session_storage = session_storage
        @is_refreshing_session = false
      end

      # Performs a network request based on a passed request model
      #
      # @param model [Fabricio::Networking::RequestModel]
      # @return [String]
      def perform_request(model)
        session = @session_storage.obtain_session
        model = sign_model(model, session)

        connection = Faraday.new(:url => model.base_url) do |faraday|
          faraday.adapter Faraday.default_adapter
        end

        if model.type == :GET
          result = perform_get_request(connection, model)
        elsif model.type == :POST
          result = perform_post_request(connection, model)
        end

        check_authorization(model, result)
      end

      private

      # Signs a request model with authorization data
      #
      # @param model [Fabricio::Networking::RequestModel]
      # @param session [Fabricio::Authorization::Session]
      # @return [String]
      def sign_model(model, session)
        model.headers['Authorization'] = "Bearer #{session.access_token}"
        model
      end

      # Performs a GET network request based on a passed request model
      #
      # @param connection [Faraday::Connection]
      # @param model [Fabricio::Networking::RequestModel]
      # @return [String]
      def perform_get_request(connection, model)
        connection.get do |req|
          req.url model.api_path
          req.headers = model.headers
          req.params = model.params
        end
      end

      # Performs a POST network request based on a passed request model
      #
      # @param connection [Faraday::Connection]
      # @param model [Fabricio::Networking::RequestModel]
      # @return [String]
      def perform_post_request(connection, model)
        connection.post do |req|
          req.url model.api_path
          req.headers = model.headers
          req.body = model.body
        end
      end

      # Perform retry if network response not authorizate
      #
      # @param model [Fabricio::Networking::RequestModel]
      # @param result [Fabricio::Networking::ResponseModel]
      # @return [String]
      def check_authorization(model, result)
        # If there is an authorization error and we aren't already trying to refresh it, we make a refresh session call and retry the initial network request.
        is_authorization_error = is_authorization_error(result)
        if is_authorization_error && @is_refreshing_session == false
          session = @session_storage.obtain_session
          refreshed_session = @authorization_client.refresh(session)
          @session_storage.store_session(refreshed_session)

          @is_refreshing_session = true
          return perform_request(model)
        end

        # If authorization returns 401 and refresh session operation failed we throw exception
        if is_authorization_error && @is_refreshing_session == true
          raise StandardError.new('Can`t refresh session. Try once again later or repeat authorization manually')
        end

        if is_authorization_error == false
          @is_refreshing_session = false
        end
        result
      end

      # Check network response on success authorization
      #
      # @param result [Fabricio::Networking::ResponseModel]
      # @return [Bool]
      def is_authorization_error(result)
        result.success? == false && [401, 402].include?(result.status)
      end
    end
  end
end
