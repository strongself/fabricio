require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'organization'
require_relative 'app'
require_relative 'build'
require_relative 'cli_helper'

module Fabricio
  class CLI < Thor

    desc "organization", "..."
    subcommand "organization", Organization

    desc "app", "..."
    subcommand "app", App

    desc "build", "..."
    subcommand "build", Build

    desc "credential", "Setup credential"
    def credential
      say("Setup credential")
      credential = ask_credential

      tmp_client = Fabricio::Client.new do |config|
        config.username = credential.email
        config.password = credential.password
      end

      organization = tmp_client.organization.get
      unless organization.nil?
        say("Successful login to #{organization.name}")
        create_credential_file(credential)
      else
        say("Login failed")
      end

      say("Complete!")
    end

  end
end
