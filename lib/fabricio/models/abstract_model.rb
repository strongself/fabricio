module Fabricio
  module Model
    # Defines a base class for all data models
    class AbstractModel
      # Plain data from the server
      attr_accessor :json

      # We use `method_missing` approach here to allow a user query any field from the original data structure sent by server.
      def method_missing(*args)
        method_name = args.first
        json_value = @json[method_name.to_s]
        return json_value if json_value
        raise NoMethodError.new("There's no method called #{args.first} here -- please try again.", args.first)
      end

      def to_s
        @json
      end
    end
  end
end
