require 'json'
require 'fabricio/networking/request_model'

module Fabricio
  module Networking
    # This factory creates request models for fetching data for App model object
    class RequestModelFactory
      # Server constants
      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_GRAPHQL_API_URL = 'https://api-dash.fabric.io/graphql'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_API_3_PATH = '/api/v3'
      FABRIC_APPS_ENDPOINT = '/apps'
      FABRIC_ORGANIZATIONS_ENDPOINT = '/organizations'
      FABRIC_PROJECTS_ENDPOINT = '/projects'

      def initialize(param_storage)
        @param_storage = param_storage
      end

      protected

      def stored_organization_id
        organization_id = @param_storage.organization_id
        raise NotProvidedParam, "Not provided organization_id" if organization_id.nil?
        organization_id
      end

      def stored_app_id
        app_id = @param_storage.app_id
        raise NotProvidedParam, "Not provided app_id" if app_id.nil?
        app_id
      end

      # Returns an API path to app endpoint
      #
      # @param app_id [String]
      # @return [String]
      def app_endpoint(app_id)
        app_id ||= stored_app_id
        "#{FABRIC_APPS_ENDPOINT}/#{app_id}"
      end

      # Returns an API path to app endpoint
      #
      # @param organization_id [String]
      # @return [String]
      def org_endpoint(organization_id)
        organization_id ||= stored_organization_id
        "#{FABRIC_ORGANIZATIONS_ENDPOINT}/#{organization_id}"
      end

      # Returns an API path to organization endpoint
      #
      # @param organization_id [String]
      # @param app_id [String]
      # @return [String]
      def org_app_endpoint(organization_id, app_id)
        "#{org_endpoint(organization_id)}#{app_endpoint(app_id)}"
      end

    end
  end
end
