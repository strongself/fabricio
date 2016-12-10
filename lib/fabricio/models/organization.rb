require 'fabricio/models/abstract_model'

module Fabricio
  module Model
    class Organization < AbstractModel
      attr_reader :id, :alias, :name, :apps_counts

      def initialize(attributes)
        @id = attributes['id']
        @alias = attributes['alias']
        @name = attributes['name']
        @apps_counts = attributes['apps_counts']
        @json = attributes
      end
    end
  end
end