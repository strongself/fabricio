require 'fabricio/networking/build_request_model_factory'
require 'fabricio/networking/network_client'
require 'fabricio/models/build'

module Fabricio
  module Service
    # Service responsible for fetching different Build information
    class BuildService

      # Initializes a new BuildService object.
      #
      # @param session [Fabricio::Authorization::Session]
      # @param network_client [Fabricio::Networking::NetworkClient]
      # @return [Fabricio::Service::BuildService]
      def initialize(session, network_client)
        @session = session

        @request_model_factory = Fabricio::Networking::BuildRequestModelFactory.new
        @network_client = network_client
      end

      # Obtains the list of all application builds
      #
      # @param app_id [String] Application identifier
      # @return [Array<Fabricio::Model::Build>]
      def all(app_id)
        request_model = @request_model_factory.all_builds_request_model(@session, app_id)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['instances'].map do |hash|
          Fabricio::Model::Build.new(hash)
        end
      end

      # Obtains a specific build for a specific application
      #
      # @param app_id [String] Application identifier
      # @param version [String] Build version. E.g. '4.0.1'.
      # @param build_number [String] Build number. E.g. '39'.
      # @return [Fabricio::Model::Build]
      def get(app_id, version, build_number)
        request_model = @request_model_factory.get_build_request_model(@session, app_id, version, build_number)
        response = @network_client.perform_request(request_model)
        Fabricio::Model::Build.new(JSON.parse(response.body)['instances'].first)
      end

    end
  end
end
