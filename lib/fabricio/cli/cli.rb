require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'organization'
require_relative 'app'
require_relative 'cli_helper'

module Fabricio
  class CLI < Thor

    desc "organization", "..."
    subcommand "organization", Organization

    desc "app", "..."
    subcommand "app", App

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

    desc "builds", "Obtain all builds"
    option :app_id => :required, :type => :string
    option :short, :type => :boolean
    def builds(app_id)
      if options[:short]
        builds = client.build.all(app_id)
        say(builds.map {|build| build.pretty_print}.join("\n\n"))
      else
        say("#{client.build.all(app_id).to_s}")
      end
    end

    desc "build", "Obtain single build"
    option :app_id => :required, :type => :string
    option :version => :required, :type => :string
    option :build_number => :required, :type => :string
    option :short, :type => :boolean
    def build(app_id, version, build_number)
      if options[:short]
        say("#{client.build.get(app_id, version, build_number).pretty_print}")
      else
        say("#{client.build.get(app_id, version, build_number).to_s}")
      end
    end

  end
end
