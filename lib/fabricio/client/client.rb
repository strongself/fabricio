require 'fabricio/models/organization'
require 'fabricio/services/organization_service'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/session'
require 'fabricio/authorization/memory_session_storage'

module Fabricio
  class Client
    VALID_OPTIONS_KEYS = [:client_id, :client_secret, :username, :password, :session_storage].freeze

    DEFAULT_CLIENT_ID = nil
    DEFAULT_CLIENT_SECRET = nil
    DEFAULT_USERNAME = nil
    DEFAULT_PASSWORD = nil
    DEFAULT_SESSION_STORAGE = Fabricio::Authorization::MemorySessionStorage.new

    attr_accessor *VALID_OPTIONS_KEYS, :organization

    def initialize(options =
                       {
                           :client_id => DEFAULT_CLIENT_ID,
                           :client_secret => DEFAULT_CLIENT_SECRET,
                           :username => DEFAULT_USERNAME,
                           :password => DEFAULT_PASSWORD,
                           :session_storage => DEFAULT_SESSION_STORAGE
                       })
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?

      @auth_client = Fabricio::Authorization::AuthorizationClient.new(@session_storage)
      session = obtain_session
      @organization_service ||= Fabricio::Service::OrganizationService.new(session)
    end

    def method_missing(*args, &block)
      service = instance_variable_get("@#{args.first}_service")
      return service if service
      call_method(args, &block)
    end

    private

    def obtain_session
      @auth_client.auth(@username,
                        @password,
                        @client_id,
                        @client_secret)
    end
  end
end
