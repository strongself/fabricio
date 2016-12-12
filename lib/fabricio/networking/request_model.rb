module Fabricio
  module Networking
    class RequestModel
      attr_accessor :type, :base_url, :api_path, :headers, :body, :params

      def initialize(options =
                         {
                             :type => :GET,
                             :base_url => '',
                             :api_path => '',
                             :headers => {},
                             :body => nil,
                             :params => {}
                         })
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
        yield(self) if block_given?
      end
    end
  end
end
