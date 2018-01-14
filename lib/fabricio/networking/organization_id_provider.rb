require 'fabricio/models/app'

module Fabricio
  module Networking
    # Maps app ids to organization ids
    class OrganizationIdProvider

      # Initializes a new OrganizationIdProvider object
      #
      # @param app_list_provider A lambda that takes no arguments and returns [Array<Fabricio::Model::App>]
      # @return [Fabricio::Networking::OrganizationIdProvider]
      def initialize(app_list_provider)
        @app_list_provider = app_list_provider
        @app_list = nil
      end

      # Returns the organization id of the given app id
      #
      # @param app_id [String] Application identifier
      # @return [String] The organization identifier to which it belongs
      def get(app_id)
        app_list = obtain_app_list
        candidate = app_list.select do |app|
          app.id == app_id
        end
        raise "Could not find application with id #{app_id}" unless candidate.size > 0
        candidate.first.organization_id
      end

      private def obtain_app_list()
        app_list = @app_list
        if !app_list
          app_list = @app_list_provider.call
          @app_list = app_list
        end

        app_list
      end
    end
  end
end
