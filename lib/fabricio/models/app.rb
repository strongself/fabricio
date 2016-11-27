require 'faraday'
require 'json'
require 'fabricio/authorization/session'

API_URL = 'https://fabric.io'
INSTANT_API_URL = 'https://instant.fabric.io'

module Fabricio
  class App
    attr_reader :id, :name, :bundle_id, :created_at, :platform, :icon_url

    def initialize(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @bundle_id = attributes['bundle_identifier']
      @created_at = attributes['created_at']
      @platform = attributes['platform']
      @icon_url = attributes['icon_url']
    end

    # Networking

    def self.all(session)
      conn = Faraday.new(:url => API_URL) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      response = conn.get do |req|
        req.url '/api/v2/apps'
        req.headers['Authorization'] = "Bearer #{session.access_token}"
      end
      apps = Array.new
      JSON.parse(response.body).each do |app_hash|
        apps.push(App.new(app_hash))
      end
      apps
    end

    def self.find(id, session)
      conn = Faraday.new(:url => API_URL) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      response = conn.get do |req|
        req.url "/api/v2/apps/#{id}"
        req.headers['Authorization'] = "Bearer #{session.access_token}"
      end
      App.new(JSON.parse(response.body))
    end

    def self.active_now(app_id, organization_id, session)
      conn = Faraday.new(:url => INSTANT_API_URL) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      response = conn.get do |req|
        req.url "/api/v2/organizations/#{organization_id}/apps/#{app_id}/growth_analytics/active_now.json"
        req.headers['Authorization'] = "Bearer #{session.access_token}"
      end
      JSON.parse(response.body)['cardinality']
    end
  end
end
