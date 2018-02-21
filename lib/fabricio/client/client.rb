require 'fabricio/models/organization'
require 'fabricio/services/organization_service'
require 'fabricio/services/app_service'
require 'fabricio/services/build_service'
require 'fabricio/services/version_service'
require 'fabricio/authorization/authorization_client'
require 'fabricio/authorization/session'
require 'fabricio/authorization/memory_session_storage'
require 'fabricio/authorization/memory_param_storage'
require 'fabricio/networking/network_client'

module Fabricio
  # The main object of the gem. It's used to initiate all data requests.
  class Client
    # Default values for initialization parameters
    # clientId and clientSecret are taken from Android application.
    DEFAULT_CLIENT_ID = '2c18f8a77609ee6bbac9e53f3768fedc45fb96be0dbcb41defa706dc57d9c931'
    DEFAULT_CLIENT_SECRET = '092ed1cdde336647b13d44178932cba10911577faf0eda894896188a7d900cc9'
    DEFAULT_USERNAME = nil
    DEFAULT_PASSWORD = nil
    # In-memory session storage is used by default
    DEFAULT_SESSION_STORAGE = Fabricio::Authorization::MemorySessionStorage.new
    DEFAULT_PARAM_STORAGE = Fabricio::Authorization::MemoryParamStorage.new

    attr_accessor :client_id, :client_secret, :username, :password, :session_storage, :param_storage;

    def default_options
      {
          :client_id => DEFAULT_CLIENT_ID,
          :client_secret => DEFAULT_CLIENT_SECRET,
          :username => DEFAULT_USERNAME,
          :password => DEFAULT_PASSWORD,
          :session_storage => DEFAULT_SESSION_STORAGE,
          :param_storage => DEFAULT_PARAM_STORAGE,
          :params => {}
      }
    end

    # Initializes a new Client object. You can use a block to fill all the options:
    # client = Fabricio::Client.new do |config|
    #   config.username = 'email@rambler.ru'
    #   config.password = 'pa$$word'
    # end
    #
    # After initializing you can query this client to get data:
    # client.app.all
    # client.app.active_now('app_id')
    #
    # @param options [Hash] Hash containing customizable options
    # @option options [String] :client_id Client identifier. You can take it from the 'Organization' section in Fabric.io settings.
    # @option options [String] :client_secret Client secret key. You can take it from the 'Organization' section in Fabric.io settings.
    # @option options [String] :username Your Fabric.io username
    # @option options [String] :password Your Fabric.io password
    # @option options [Fabricio::Authorization::AbstractSessionStorage] :session_storage Your custom AbstractSessionStorage subclass that provides its own logic of storing session data.
    # @option options [Fabricio::Authorization::AbstractParamStorage] :param_storage  Your custom AbstractParamStorage subclass that provides its own logic of storing params.
    # @option options [Hash] Default params
    # @return [Fabricio::Client]
    def initialize(options = default_options)
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?

      @auth_client = Fabricio::Authorization::AuthorizationClient.new
      if obtain_session.nil?
        raise StandardError.new("Session is empty: #{auth_data}")
      end
      network_client = Fabricio::Networking::NetworkClient.new(@auth_client, @session_storage)

      @organization_service ||= Fabricio::Service::OrganizationService.new(param_storage, network_client)
      @app_service ||= Fabricio::Service::AppService.new(param_storage, network_client)
      @build_service ||= Fabricio::Service::BuildService.new(param_storage, network_client)
      @version_service ||= Fabricio::Service::VersionService.new(param_storage, network_client)

      param_storage.store(options[:params]) unless options[:params].empty?
      fill_default_params
    end

    # We use `method_missing` approach instead of explicit methods.
    # Generally, look at the initialized services and use the first part of their names as a method.
    # app_service -> client.app
    #
    # # @raise [NoMethodError] Error raised when unsupported method is called.
    def method_missing(*args)
      service = instance_variable_get("@#{args.first}_service")
      return service if service
      raise NoMethodError.new("There's no method called #{args.first} here -- please try again.", args.first)
    end

    private

    # Obtains current session. If there is no cached session, it sends a request to OAuth API to get access and refresh tokens.
    #
    # @return [Fabricio::Authorization::Session]
    def obtain_session
      session = @session_storage.obtain_session
      if session.nil?
        session = @auth_client.auth(@username,
                                    @password,
                                    @client_id,
                                    @client_secret)
        @session_storage.store_session(session)
      end

      session
    end

    # Obtain organizations and apps and save as default if is only one
    def fill_default_params
      fill_organization
      fill_app
    end

    # Obtain organizations and save as default if is only one
    def fill_organization
      if @param_storage.organization_id == nil
        organizations = @organization_service.all
        @param_storage.store_organization_id(organizations[0].id) if organizations.count == 1
      end
    end

    # Obtain apps and save as default if is only one
    def fill_app
      if @param_storage.app_id == nil
        apps = @app_service.all
        @param_storage.store_app_id(apps[0].id) if apps.count == 1
      end
    end
  end
end
