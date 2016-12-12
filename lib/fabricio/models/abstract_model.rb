module Fabricio
  module Model
    class AbstractModel
      attr_reader :json

      def method_missing(*args)
        method_name = args.first
        json_value = @json[method_name.to_s]
        return json_value if json_value
        raise NoMethodError.new("There's no method called #{args.first} here -- please try again.", args.first)
      end
    end
  end
end
