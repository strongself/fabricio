module Fabricio
  module Authorization
    # A class providing an interface for implementing Fabric session storage. Subclass it to provide your own behaviour (e.g. storing session data in database)
    class AbstractParamStorage

    # Returns all stored variable
    #
    # @return [Hash]
    def obtain
      raise NotImplementedError, "Implement this method in a child class"
    end

    # Save variable
    #
    # @param hash [Hash]
    def store(_)
      raise NotImplementedError, "Implement this method in a child class"
    end

    # Resets current state and deletes all saved params
    def reset
      raise NotImplementedError, "Implement this method in a child class"
    end

    def organization_id
      raise NotImplementedError, "Implement this method in a child class"
    end

    def app_id
      raise NotImplementedError, "Implement this method in a child class"
    end

    def store_organization_id(_)
      raise NotImplementedError, "Implement this method in a child class"
    end

    def store_app_id(_)
      raise NotImplementedError, "Implement this method in a child class"
    end
    end
  end
end
