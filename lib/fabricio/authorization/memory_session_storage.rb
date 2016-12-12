require 'fabricio/authorization/abstract_session_storage'

module Fabricio
  module Authorization
    # The only one built-in session storage. Stores current session in memory.
    class MemorySessionStorage < AbstractSessionStorage

      # Initializes a new MemorySessionStorage object
      #
      # @return [Fabricio::Authorization::MemorySessionStorage]
      def initialize
        @session = nil
      end

      # Returns session stored in a variable
      #
      # @return [Fabricio::Authorization::Session]
      def obtain_session
        @session
      end

      # Stores session in a variable
      #
      # @param session [Fabricio::Authorization::MemorySessionStorage]
      def store_session(session)
        @session = session
      end

      # Resets current state and deletes saved session
      def reset
        @session = nil
      end
    end
  end
end