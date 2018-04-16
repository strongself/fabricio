require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    # This model represents a custom event type
    class CustomEventType < AbstractModel
      attr_reader :type, :key, :count

      # Returns a CustomEventType model object
      #
      # @param attributes [Hash]
      # @return [Fabricio::Model::CustomEventType]
      def initialize(attributes)
        @type = attributes['event_type']
        @count = attributes['event_count']
        @key = attributes['event_key']
        @json = attributes
      end
    end
  end
end
