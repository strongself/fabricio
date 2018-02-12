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

      protected

      # Returns an API path to app endpoint
      #
      # @param app_id [String]
      # @return [String]
      def app_endpoint(app_id)
        "#{FABRIC_APPS_ENDPOINT}/#{app_id}"
      end

      # Returns an API path to app endpoint
      #
      # @param session [Fabricio::Authorization::Session]
      # @return [String]
      def org_endpoint(session)
        "#{FABRIC_ORGANIZATIONS_ENDPOINT}/#{session.organization_id}"
      end

      # Returns an API path to organization endpoint
      #
      # @param session [Fabricio::Authorization::Session]
      # @param app_id [String]
      # @return [String]
      def org_app_endpoint(session, app_id)
        "#{org_endpoint(session)}#{app_endpoint(app_id)}"
      end

    end
  end
end
