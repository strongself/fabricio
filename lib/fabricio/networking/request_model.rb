module Fabricio
  module Networking
    class RequestModel
      attr_reader :type, :base_url, :api_path, :headers, :body

      def initialize(type = :GET, base_url = '', api_path = '', headers = {}, body = nil)
        @type = type
        @base_url = base_url
        @api_path = api_path
        @headers = headers
        @body = body
      end
    end
  end
end
