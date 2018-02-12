require 'fabricio/networking/request_model'

module Fabricio
  module Networking
    # This factory creates request models for fetching data for Build model object
    class BuildRequestModelFactory

      # Server constants
      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_APPS_ENDPOINT = '/apps'
      FABRIC_ORGANIZATIONS_ENDPOINT = '/organizations'

      # Initializes a new BuildRequestModelFactory object
      #
      # @param organization_id_provider [Fabricio::Networking::OrganizationIdProvider]
      # @return [Fabricio::Networking::BuildRequestModelFactory]
      def initialize(organization_id_provider)
        @organization_id_provider = organization_id_provider
      end

      # Returns a request model for obtaining the list of all builds for a specific app
      #
      # @param app_id [String]
      # @return [Fabricio::Networking::RequestModel]
      def all_builds_request_model(app_id)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(app_id)}/beta_distribution/releases"
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
        end
        model
      end

      # Returns a request model for obtaining a specific build for a specific app
      #
      # @param app_id [String]
      # @param version [String] The version number. E.g. '4.0.0'
      # @param build_number [String] The build number. E.g. '48'
      # @return [Fabricio::Networking::RequestModel]
      def get_build_request_model(app_id, version, build_number)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(app_id)}/beta_distribution/releases"
        params = {
            'app[display_version]' => version,
            'app[build_version]' => build_number
        }
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      # Returns a request model for obtaining an array of top versions for a given app
      #
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Networking::RequestModel]
      def top_versions_request_model(app_id, start_time, end_time)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(app_id)}/growth_analytics/top_builds"
        params = {
            'app_id' => app_id,
            'start' => start_time,
            'end' => end_time
        }
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      private

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
      # @param app_id [String]
      # @return [String]
      def org_app_endpoint(app_id)
        organization_id = @organization_id_provider.get(app_id)
        "#{org_endpoint(organization_id)}#{app_endpoint(app_id)}"
      end

    end
  end
end
