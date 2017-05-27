require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    # This model represents an application build
    class Issue < AbstractModel
      attr_reader :id,
      :displayId,
      :externalId,
      :title,
      :subtitle,
      :createdAt,
      :type,
      :state,
      :latestSessionId,
      :occurrenceCount,
      :impactedDevices

      # Returns a Build model object
      #
      # @param attributes [Hash]
      # @return [Fabricio::Model::Build]
      def initialize(attributes)
        @id = attributes['id']
        @displayId = attributes['displayId']
        @externalId = attributes['externalId']
        @title = attributes['title']
        @subtitle = attributes['subtitle']
        @createdAt = attributes['createdAt']
        @type = attributes['type']
        @state = attributes['state']
        @latestSessionId = attributes['latestSessionId']
        @occurrenceCount = attributes['occurrenceCount']
        @impactedDevices = attributes['impactedDevices']
        @json = attributes
      end
    end
  end
end
