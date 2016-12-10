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

      def top

      end

      def get(id)

      end
    end
  end
end
