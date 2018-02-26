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
      def all_versions_request_model(options = {})
        options = {
          :app_id => stored_app_id,
          :page => 1,
          :per_page => 100
        }.merge(options)
        validate_options(options)
        path = "#{FABRIC_API_3_PATH}#{FABRIC_PROJECTS_ENDPOINT}/#{options[:app_id]}/versions"
        params = {
            'fields' => 'id,synthesized_version,major,minor,collect_reports,status,starred',
            'page' => options[:page],
            'per_page' => options[:per_page]
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
      def top_versions_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id,
          :start_time => day_ago_timestamp,
          :end_time => today_timestamp
        }.merge(options)
        validate_options(options)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(options[:organization_id], options[:app_id])}/growth_analytics/top_builds"
        params = {
            'app_id' => options[:app_id],
            'start' => options[:start_time],
            'end' => options[:end_time]
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
