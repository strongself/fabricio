require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    # This model represents a custom event attribute value
    class CustomEventAttributeValue < AbstractModel
      attr_reader :attribute_value,
      :count,
      :percent,
      :week_ago_delta

      # Returns a CustomEventAttributeValue model object
      #
      # @param attributes [Hash]
      # @return [Fabricio::Model::CustomEventAttributeValue]
      def initialize(attributes)
        @attribute_value = attributes['attribute_value']
        @count = attributes['count']
        @percent = attributes['percent']
        @week_ago_delta = attributes['week_ago_delta']
        @json = attributes
      end
    end
  end
end
