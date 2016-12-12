module Fabricio
  module Networking
    # A data structure that provides all values necessary for making an API request
    class RequestModel

      attr_accessor :type, :base_url, :api_path, :headers, :body, :params

      # Initializes a new RequestModel object. You can use a block to fill all the options:
      # model = Fabricio::Networking::RequestModel.new do |config|
      #   config.type = :GET
      #   config.base_url = FABRIC_API_URL
      #   config.api_path = '/apps'
      # end
      #
      # @param options [Hash] Hash containing customizable options
      # @option options [String] :type Request type - :GET or :POST
      # @option options [String] :base_url The base_url. E.g. 'https://fabric.io'
      # @option options [String] :api_path An API endpoint path. E.g. '/apps'
      # @option options [Hash] :headers All request headers
      # @option options [Hash] :body Request body
      # @option options [Hash] :params Request url parameters
      # @return [Fabricio::Networking::RequestModel]
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
