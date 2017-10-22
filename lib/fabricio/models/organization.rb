require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    # This model represents an organization
    class Organization < AbstractModel
      attr_reader :id, :alias, :name, :apps_counts

      # Returns a Build model object
      #
      # @param attributes [Hash]
      # @return [Fabricio::Model::Organization]
      def initialize(attributes)
        @id = attributes['id']
        @alias = attributes['alias']
        @name = attributes['name']
        @apps_counts = attributes['apps_counts']
        @json = attributes
      end

      # Returns a readable object representation
      #
      # @return [String]
      def pretty_print
        "name: #{@name}\nid: #{@id}\nalias: #{@alias}"
      end
    end
  end
end
