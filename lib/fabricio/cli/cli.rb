require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require 'fabricio/authorization/file_session_storage'
require_relative 'organization'
require_relative 'app'
require_relative 'build'
require_relative 'version'
require_relative 'cli_helper'


module Fabricio
  class CLI < Thor

    desc "organization", "..."
    subcommand "organization", Organization

    desc "app", "..."
    subcommand "app", App

    desc "build", "..."
    subcommand "build", Build

    desc "version", "..."
    subcommand "version", Version

    desc "credential", "Setup credential"
    def credential
      say("Setup credential")
      credential = ask_credential

      tmp_client = Fabricio::Client.new do |config|
        config.username = credential.email
        config.password = credential.password
        config.session_storage = FileSessionStorage()
      end

      say("Your session store in #{SESSION_FILE_PATH}")

      organization = tmp_client.organization.get
      unless organization.nil?
        say("Successful login")
      else
        say("Login failed")
      end

      say("Complete!")
    end

  end
end
