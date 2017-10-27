require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    # This model represents an application
    class App < AbstractModel
      attr_reader :id, :name, :bundle_id, :created_at, :platform, :icon_url

      # Returns an App model object
      #
      # @param attributes [Hash]
      # @return [Fabricio::Model::App]
      def initialize(attributes)
        @id = attributes['id']
        @name = attributes['name']
        @bundle_id = attributes['bundle_identifier']
        @created_at = attributes['created_at']
        @platform = attributes['platform']
        @icon_url = attributes['icon_url']
        @json = attributes
      end

    end
  end
end
