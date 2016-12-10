module Fabricio
  module Model
    class Point
      attr_reader :date, :value

      def initialize(attributes)
        @date = DateTime.strptime(attributes.first.to_s,'%s')
        @value = attributes.last
      end
    end
  end
end