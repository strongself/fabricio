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
        @occurrenceCount = attributes['_occurrenceCount2I980d"']
        @impactedDevices = attributes['_impactedDevices2oATOx']
        @json = attributes
      end
    end
  end
end
