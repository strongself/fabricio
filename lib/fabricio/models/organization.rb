require 'faraday'
require 'json'
require 'fabricio/authorization/session'

API_URL = 'https://fabric.io'

module Fabricio
  class Organization
    attr_reader :id, :alias, :name, :apps_counts

    def initialize(attributes)
      @id = attributes['id']
      @alias = attributes['alias']
      @name = attributes['name']
      @apps_counts = attributes['apps_counts']
    end

    # Networking

    @conn = Faraday.new(:url => API_URL) do |faraday|
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    def self.find(session)
      response = @conn.get do |req|
        req.url '/api/v2/organizations'
        req.headers['Authorization'] = "Bearer #{session.access_token}"
      end
      Organization.new(JSON.parse(response.body)[0])
    end
  end
end