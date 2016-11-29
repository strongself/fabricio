require 'fabricio/authorization/session'

module Fabricio
  module Authorization
    class AbstractSessionStorage
      def store_session(session)
        raise NotImplementedError, "Implement this method in a child class"
      end

      def reset
        raise NotImplementedError, "Implement this method in a child class"
      end
    end
  end
end