module Fabricio
  module Authorization
    # This class is a data structure that holds tokens and identifiers necessary for making API requests.
    class Session
      attr_reader :access_token, :refresh_token

      # Initializes a new Session object
      #
      # @param attributes [Hash] Hash containing access and refresh tokens
      # @option options [String] :access_token OAuth access token
      # @option options [String] :refresh_token OAuth refresh token
      # @return [Fabricio::Authorization::Session]
      def initialize(attributes = {})
        @access_token = attributes['access_token']
        @refresh_token = attributes['refresh_token']
      end

      # Obtain hash with access_token and refresh_token
      #
      # @return [Hash]
      def hash
        return {} unless access_token && refresh_token
        return {
            'access_token' => access_token,
            'refresh_token' => refresh_token
        }
      end
    end
  end
end
