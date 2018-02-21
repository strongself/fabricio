require 'fabricio/networking/request_model_factory'
require 'fabricio/networking/request_model'

module Fabricio
  module Networking
    # This factory creates request models for fetching data for Version model object
    class VersionRequestModelFactory < RequestModelFactory

      # Returns a request model for obtaining the list of all versions for a specific app
      #
      # @param app_id [String]
      # @param page [Int]
      # @param per_page [Int]
      # @return [Fabricio::Networking::RequestModel]
      def all_versions_request_model(app_id, page, per_page)
        path = "#{FABRIC_API_3_PATH}#{FABRIC_PROJECTS_ENDPOINT}/#{app_id}/versions"
        params = {
            'fields' => 'id,synthesized_version,major,minor,collect_reports,status,starred',
            'page' => page,
            'per_page' => per_page
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
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Networking::RequestModel]
      def top_versions_request_model(organization_id, app_id, start_time, end_time)
        app_id ||= stored_app_id
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(organization_id, app_id)}/growth_analytics/top_builds"
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

    end
  end
end
