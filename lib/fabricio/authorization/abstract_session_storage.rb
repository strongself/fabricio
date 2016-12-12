require 'fabricio/authorization/session'

module Fabricio
  module Authorization
    class AbstractSessionStorage
      def obtain_session
        raise NotImplementedError, "Implement this method in a child class"
      end

      def store_session(_)
        raise NotImplementedError, "Implement this method in a child class"
      end

      def reset
        raise NotImplementedError, "Implement this method in a child class"
      end
    end
  end
end