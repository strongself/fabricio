module Fabricio
  module Model
    # This model represents a credential
    class Credential
      attr_reader :email, :password

      # Returns a Credential model object
      #
      # @param email [String]
      # @param password [String]
      # @return [Fabricio::Model::Credential]
      def initialize(email, password)
        @email = email
        @password = password
      end
    end
  end
end
