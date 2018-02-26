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

      def validate_options(options)
        options.each do |key, value|
          begin
            raise NotProvidedParam if value.nil?
          rescue
            raise $!, "Not provided #{key} in options: #{options}"
          end
        end
      end

      def stored_organization_id
        @param_storage.organization_id
      end

      def stored_app_id
        @param_storage.app_id
      end

      # Returns an API path to app endpoint
      #
      # @param app_id [String]
      # @return [String]
      def app_endpoint(app_id)
        "#{FABRIC_APPS_ENDPOINT}/#{app_id}"
      end

      # Returns an API path to app endpoint
      #
      # @param organization_id [String]
      # @return [String]
      def org_endpoint(organization_id)
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

      # Return week ago timestamp
      #
      # @return [Int]
      def week_ago_timestamp
        (Time.now - 60 * 60 * 24 * 7).to_i
      end

      # Return day ago timestamp
      #
      # @return [Int]
      def day_ago_timestamp
        (Time.now - 60 * 60 * 24).to_i
      end

      # Return now timestamp
      #
      # @return [Int]
      def today_timestamp
        Time.now.to_i
      end

    end
  end
end
