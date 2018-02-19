require 'fabricio/networking/build_request_model_factory'
require 'fabricio/networking/network_client'
require 'fabricio/models/build'

module Fabricio
  module Service
    # Service responsible for fetching different Build information
    class BuildService

      # Initializes a new BuildService object.
      #
      # @param param_storage [Fabricio::Authorization::AbstractParamStorage]
      # @param network_client [Fabricio::Networking::NetworkClient]
      # @return [Fabricio::Service::BuildService]
      def initialize(param_storage, network_client)
        @request_model_factory = Fabricio::Networking::BuildRequestModelFactory.new(param_storage)
        @network_client = network_client
      end

      # Obtains the list of all application builds
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @return [Array<Fabricio::Model::Build>]
      def all(organization_id = nil, app_id = nil)
        request_model = @request_model_factory.all_builds_request_model(organization_id, app_id)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['instances'].map do |hash|
          Fabricio::Model::Build.new(hash)
        end
      end

      # Obtains a specific build for a specific application
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param version [String] Build version. E.g. '4.0.1'.
      # @param build_number [String] Build number. E.g. '39'.
      # @return [Fabricio::Model::Build]
      def get(organization_id = nil, app_id = nil, version, build_number)
        request_model = @request_model_factory.get_build_request_model(organization_id, app_id, version, build_number)
        response = @network_client.perform_request(request_model)
        Fabricio::Model::Build.new(JSON.parse(response.body)['instances'].first)
      end

    end
  end
end
