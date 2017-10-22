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

      # Returns a readable object representation
      #
      # @return [String]
      def pretty_print
        "name: #{@name}\nid: #{@id}\nbundle_id: #{@bundle_id}\ncreated_at: #{@created_at}\nplatform: #{@platform}\nicon_url: #{@icon_url}"
      end
    end
  end
end
