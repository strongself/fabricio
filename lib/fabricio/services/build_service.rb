require 'fabricio/networking/build_request_model_factory'
require 'fabricio/networking/network_client'
require 'fabricio/models/build'

module Fabricio
  module Service
    class BuildService

      def initialize(session)
        @session = session

        @request_model_factory = Fabricio::Networking::BuildRequestModelFactory.new
        @network_client = Fabricio::Networking::NetworkClient.new
      end

      def all(app_id)
        request_model = @request_model_factory.all_builds_request_model(@session, app_id)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['instances'].map do |hash|
          Fabricio::Model::Build.new(hash)
        end
      end

      def get(app_id, version, build_number)
        request_model = @request_model_factory.get_build_request_model(@session, app_id, version, build_number)
        response = @network_client.perform_request(request_model)
        Fabricio::Model::Build.new(JSON.parse(response.body)['instances'].first)
      end

      def top_versions(app_id, start_time, end_time)
        request_model = @request_model_factory.top_versions_request_model(@session, app_id, start_time, end_time)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['builds']
      end
    end
  end
end
