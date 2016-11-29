module Fabricio
  module Configuration
    VALID_OPTIONS_KEYS= [:client_id, :client_secret, :username, :password].freeze

    DEFAULT_CLIENT_ID = nil
    DEFAULT_CLIENT_SECRET = nil
    DEFAULT_USERNAME = nil
    DEFAULT_PASSWORD = nil

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def reset
      self.client_id = DEFAULT_CLIENT_ID
      self.client_secret = DEFAULT_CLIENT_SECRET
      self.username = DEFAULT_USERNAME
      self.password = DEFAULT_PASSWORD
    end
  end
end

module Fabricio
  extend Configuration
end