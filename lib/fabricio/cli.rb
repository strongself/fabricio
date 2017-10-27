require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'

module Fabricio
  class CLI < Thor

    # Constants
    CREDENTIAL_DIRECTORY_PATH = "#{Dir.home}/.fabricio"
    CREDENTIAL_FILE_PATH = "#{CREDENTIAL_DIRECTORY_PATH}/.credential"
    FABRIC_GRAPHQL_API_URL = 'https://api-dash.fabric.io/graphql'

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

    desc "organization", "Obtain organization"
    option :app_id => :required, :type => :string
    option :short, :type => :boolean
    def organization
      if options[:short]
        say(client.organization.get.pretty_print)
      else
        say("#{client.organization.get.to_s}")
      end
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

    private
    def client
      email = ""
      password = ""
      if File.file?(CREDENTIAL_FILE_PATH)
        credential = YAML.load_file(CREDENTIAL_FILE_PATH)
        email = credential['email']
        password = credential['password']
      else
        ask_credential
      end

      client = Fabricio::Client.new do |config|
        config.username = email
        config.password = password
      end
    end

    def create_credential_file(credential)
      FileUtils.mkdir_p(CREDENTIAL_DIRECTORY_PATH)
      credential_hash = {
        "email" => credential.email,
        "password" => credential.password
      }
      File.open(CREDENTIAL_FILE_PATH,'w') do |f|
          f.write credential_hash.to_yaml
      end
      say("Your credential in #{CREDENTIAL_FILE_PATH}")
    end

    def ask_credential
      say("We have to know you're email from fabric account")
      email = ask("email: ")
      say("Now we want your password. Do not be afraid, it is stored locally")
      password = ask("password: ", :echo => false)
      say("")
      Fabricio::Model::Credential.new(email, password)
    end

  end
end
