require 'fabricio/networking/request_model_factory'
require 'fabricio/networking/request_model'

module Fabricio
  module Networking
    # This factory creates request models for fetching data for Build model object
    class BuildRequestModelFactory < RequestModelFactory

      # Returns a request model for obtaining the list of all builds for a specific app
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @return [Fabricio::Networking::RequestModel]
      def all_builds_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id
        }.merge(options)
        validate_options(options)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(options[:organization_id], options[:app_id])}/beta_distribution/releases"
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
        end
        model
      end

      # Returns a request model for obtaining a specific build for a specific app
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param version [String] The version number. E.g. '4.0.0'
      # @param build_number [String] The build number. E.g. '48'
      # @return [Fabricio::Networking::RequestModel]
      def get_build_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id
        }.merge(options)
        validate_options(options)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(options[:organization_id], options[:app_id])}/beta_distribution/releases"
        params = {
            'app[display_version]' => options[:version],
            'app[build_version]' => options[:build_number]
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
