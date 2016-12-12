require 'fabricio/authorization/session'

module Fabricio
  module Authorization
    # A class providing an interface for implementing Fabric session storage. Subclass it to provide your own behaviour (e.g. storing session data in database)
    class AbstractSessionStorage

      # Override it with your own behavior of obtaining a [Fabricio::Authorization::Session] object
      #
      # @return [Fabricio::Authorization::Session]
      def obtain_session
        raise NotImplementedError, "Implement this method in a child class"
      end

      # Override it with your own behavior of storing a [Fabricio::Authorization::Session] object
      def store_session(_)
        raise NotImplementedError, "Implement this method in a child class"
      end

      # Override it with your own behavior of deleting stored [Fabricio::Authorization::Session] object
      def reset
        raise NotImplementedError, "Implement this method in a child class"
      end
    end
  end
end