require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'organization'
require_relative 'cli_helper'

module Fabricio
  class CLI < Thor

    desc "organization", "..."
    subcommand "organization", Organization

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

    desc "apps", "Obtain all app"
    option :short, :type => :boolean
    def apps
      if options[:short]
        apps = client.app.all
        say(apps.map {|app| app.pretty_print}.join("\n\n"))
      else
        say("#{client.app.all}")
      end
    end

    desc "app", "Obtain single app"
    option :app_id => :required, :type => :string
    option :short, :type => :boolean
    def app(app_id)
      if options[:short]
        say("#{client.app.get(app_id).pretty_print}")
      else
        say("#{client.app.get(app_id).to_s}")
      end
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
