require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    # This model represents a custom event attribute name
    class CustomEventAttributeName < AbstractModel
      attr_reader :type, :name

      # Returns a CustomEventAttributeName model object
      #
      # @param attributes [Hash]
      # @return [Fabricio::Model::CustomEventAttributeName]
      def initialize(attributes)
        @type = attributes['attribute_type']
        @name = attributes['attribute_name']
        @json = attributes
      end
    end
  end
end
