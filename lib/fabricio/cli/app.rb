require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'cli_helper'

module Fabricio
  class App < Thor

    desc "all", "Obtain all apps"
    option :short, :type => :boolean
    def all
      apps = client.app.all
      if options[:short]
        say(apps.map {|app| app.pretty_print}.join("\n\n"))
      else
        say(apps.map { |app| app.json }.to_json)
      end
    end

    desc "get", "Obtain single app"
    option :app_id, :type => :string
    option :short, :type => :boolean
    def get
      app = client.app.get(options[:app_id])
      if options[:short]
        say(app.pretty_print)
      else
        say(app.json.to_json)
      end
    end

    desc "active_now", "Obtain active now count"
    option :org_id, :type => :string
    option :app_id, :type => :string
    def active_now
        say(client.app.active_now(options[:org_id], options[:app_id]))
    end

    desc "issue", "Obtain issue by external_id"
    option :app_id, :type => :string
    option :external_id => :required, :type => :string
    option :short, :type => :boolean
    def issue(external_id)
      issue = client.app.single_issue(external_id, options[:app_id])
      if options[:short]
        say(issue.pretty_print)
      else
        say(issue.json.to_json)
      end
    end

    desc "session", "Obtain session"
    option :app_id, :type => :string
    option :external_id => :required, :type => :string
    option :session_id => :required, :type => :string
    option :short, :type => :boolean
    def session(external_id, session_id)
      session = client.app.issue_session(external_id, session_id, options[:app_id])
      if options[:short]
        say(session.pretty_print)
      else
        say(session.json.to_json)
      end
    end

    desc "latest_session", "Obtain latest issue session"
    option :app_id, :type => :string
    option :external_id => :required, :type => :string
    option :short, :type => :boolean
    def latest_session(external_id)
      session = client.app.issue_session(options[:app_id], external_id)
      if options[:short]
        say(session.pretty_print)
      else
        say(session.json.to_json)
      end
    end

  end
end
