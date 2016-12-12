module Fabricio
  module Authorization
    # This class is a data structure that holds tokens and identifiers necessary for making API requests.
    class Session
      attr_reader :access_token, :refresh_token, :organization_id

      # Initializes a new Session object
      #
      # @param attributes [Hash] Hash containing access and refresh tokens
      # @option options [String] :access_token OAuth access token
      # @option options [String] :refresh_token OAuth refresh token
      # @param organization_id [String]
      # @return [Fabricio::Authorization::Session]
      def initialize(attributes = {}, organization_id = '')
        @access_token = attributes['access_token']
        @refresh_token = attributes['refresh_token']
        @organization_id = organization_id
      end
    end
  end
end
