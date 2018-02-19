require 'fabricio/authorization/abstract_param_storage'

module Fabricio
  module Authorization
    # Stores default params as organization, app, etc.
    class MemoryParamStorage < AbstractParamStorage

      # Initializes a new ParamStorage object
      #
      # @return [Fabricio::Authorization::ParamStorage]
      def initialize
        @params = nil
      end

      # Returns all stored variable
      #
      # @return [Hash]
      def obtain
        @params
      end

      # Save variable
      #
      # @param hash [Hash]
      def store(hash)
        @params = hash
      end

      # Resets current state and deletes all saved params
      def reset_all
        @params = nil
      end

      def organization_id
        obtain['organization_id']
      end

      def app_id
        obtain['app_id']
      end

      def store_organization_id(organization_id)
        hash = obtain || {}
        hash['organization_id'] = organization_id
        @params = hash
      end

      def store_app_id(app_id)
        hash = obtain || {}
        hash['app_id'] = app_id
        @params = hash
      end
    end
  end
end
