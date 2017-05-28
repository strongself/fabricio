require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    # This model represents an application build
    class IssueSession < AbstractModel
      attr_reader :id,
      :created_at,
      :header_link
      :next_session_id
      :prev_session_id

      # Returns a Build model object
      #
      # @param attributes [Hash]
      # @return [Fabricio::Model::Build]
      def initialize(attributes)
        @id = attributes['session_id']
        @created_at = attributes['created_at']
        @header_link = attributes['header_link']
        @next_session_id = attributes['next_session_id']
        @prev_session_id = attributes['prev_session_id']
        @json = attributes
      end
    end
  end
end
