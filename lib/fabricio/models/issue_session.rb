require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    # This model represents an application build
    class IssueSession < AbstractModel
      attr_reader :id,
      :created_at,
      :next_session_id
      :prev_session_id

      # Returns a Build model object
      #
      # @param attributes [Hash]
      # @return [Fabricio::Model::Build]
      def initialize(attributes)
        @id = attributes['externalId']
        @created_at = attributes['createdAt']
        @next_session_id = attributes['prevSessionId']
        @prev_session_id = attributes['nextSessionId']
        @json = attributes
      end
    end
  end
end
