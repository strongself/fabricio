require 'fabricio/networking/app_request_model_factory'
require 'fabricio/networking/network_client'
require 'fabricio/models/app'

module Fabricio
  module Service
    class AppService

      def initialize(session)
        @session = session

        @request_model_factory = Fabricio::Networking::AppRequestModelFactory.new
        @network_client = Fabricio::Networking::NetworkClient.new
      end

      def all
        request_model = @request_model_factory.all_apps_request_model(@session)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body).map do |app_hash|
          Fabricio::Model::App.new(app_hash)
        end
      end

      def get(id)
        request_model = @request_model_factory.get_app_request_model(@session, id)
        response = @network_client.perform_request(request_model)
        Fabricio::Model::App.new(JSON.parse(response.body))
      end

      def active_now(id)
        request_model = @request_model_factory.active_now_request_model(@session, id)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['cardinality']
      end

      def average_daily_new(id, start_time, end_time)
        request_model = @request_model_factory.daily_new_request_model(@session, id, start_time, end_time)
        response = @network_client.perform_request(request_model)
        series = JSON.parse(response.body)['series']
        overall_count = series.inject(0) do |sum, array|
          sum + array.last
        end
        overall_count.to_f / series.count
      end

      def sessions(id, start_time, end_time, builds)

      end

      def crashes(id, start_time, end_time, builds)

      end

      def crashfree(id, start_time, end_time, builds)

      end

      def oom_free(id, start_time, end_time, builds)

      end
    end
  end
end
