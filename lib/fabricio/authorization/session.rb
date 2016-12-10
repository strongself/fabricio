module Fabricio
  module Authorization
    class Session
      attr_reader :access_token, :refresh_token, :organization_id

      def initialize(attributes = {}, organization_id = '')
        @access_token = attributes['access_token']
        @refresh_token = attributes['refresh_token']
        @organization_id = organization_id
      end
    end
  end
end
