module Fabricio
  module Model
    class Organization
      attr_reader :id, :alias, :name, :apps_counts

      def initialize(attributes)
        @id = attributes['id']
        @alias = attributes['alias']
        @name = attributes['name']
        @apps_counts = attributes['apps_counts']
      end
    end
  end
end