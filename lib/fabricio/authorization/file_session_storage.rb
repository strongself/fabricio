require 'fabricio/authorization/abstract_session_storage'
require 'fileutils'
require 'yaml'

# Constants
FABRICIO_DIRECTORY_PATH = "#{Dir.home}/.fabricio"
SESSION_FILE_PATH = "#{CREDENTIAL_DIRECTORY_PATH}/.session"

module Fabricio
  module Authorization
    # The only one built-in session storage. Stores current session in file.
    class FileSessionStorage < AbstractSessionStorage

      # Returns session stored in a variable
      #
      # @return [Fabricio::Authorization::Session]
      def obtain_session
        return nil unless File.exist?(SESSION_FILE_PATH)
        session_hash = YAML.load_file(SESSION_FILE_PATH)
        session = Session(session_hash)
        return nil unless session.access_token
        return nil unless session.refresh_token
        session
      end

      # Stores session in a variable
      #
      # @param session [Fabricio::Authorization::MemorySessionStorage]
      def store_session(session)
        FileUtils.mkdir_p(FABRICIO_DIRECTORY_PATH)
        File.open(SESSION_FILE_PATH,'w') do |f|
          f.write session.hash.to_yaml
        end
      end

      # Resets current state and deletes saved session
      def reset
        FileUtils.remove_file(SESSION_FILE_PATH)
      end
    end
  end
end
