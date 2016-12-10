require 'fabricio/authorization/abstract_session_storage'

module Fabricio
  module Authorization
    class MemorySessionStorage < AbstractSessionStorage
      def initialize
        @session = nil
      end

      def obtain_session
        @session
      end

      def store_session(session)
        @session = session
      end

      def reset
        @session = nil
      end
    end
  end
end