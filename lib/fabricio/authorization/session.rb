module Fabricio
  module Authorization
    class Session
      attr_reader :access_token, :refresh_token

      def initialize(attributes)
        @access_token = attributes['access_token']
        @refresh_token = attributes['refresh_token']
      end
    end
  end
end
