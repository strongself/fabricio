require 'faraday'
require 'fabricio/networking/request_model'

module Fabricio
  module Networking
    class NetworkClient

      def initialize(adapter = Faraday.default_adapter)
        @adapter = adapter
      end

      def perform_request(model)
        connection = Faraday.new(:url => model.base_url) do |faraday|
          faraday.adapter @adapter
        end

        if model.type == :GET
          perform_get_request(connection, model)
        elsif model.type == :POST
          perform_post_request(connection, model)
        end
      end

      private
      def perform_get_request(connection, model)
        connection.get do |req|
          req.url model.api_path
          req.headers = model.headers
          req.params = model.params
        end
      end

      def perform_post_request(connection, model)
        connection.post do |req|
          req.url model.api_path
          req.headers = model.headers
          req.body = model.body
        end
      end

    end
  end
end
