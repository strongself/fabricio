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
      hash = prepared_options(options)
      app = client.app.get(hash)
      if options[:short]
        say(app.pretty_print)
      else
        say(app.json.to_json)
      end
    end

    desc "active_now", "Obtain active now count"
    option :organization_id, :type => :string
    option :app_id, :type => :string
    def active_now
      hash = prepared_options(options)
      say(client.app.active_now(hash))
    end

    desc "issue", "Obtain issue by issue_id"
    option :app_id, :type => :string
    option :issue_id, :type => :string
    option :short, :type => :boolean
    def issue
      hash = prepared_options(options)
      issue = client.app.single_issue(hash)
      if options[:short]
        say(issue.pretty_print)
      else
        say(issue.json.to_json)
      end
    end

    desc "session", "Obtain session"
    option :app_id, :type => :string
    option :issue_id, :type => :string
    option :session_id, :type => :string
    option :short, :type => :boolean
    def session
      hash = prepared_options(options)
      session = client.app.issue_session(hash)
      if options[:short]
        say(session.pretty_print)
      else
        say(session.json.to_json)
      end
    end

    desc "latest_session", "Obtain latest issue session"
    option :app_id, :type => :string
    option :issue_id, :type => :string
    option :short, :type => :boolean
    def latest_session
      hash = prepared_options(options)
      session = client.app.issue_session(hash)
      if options[:short]
        say(session.pretty_print)
      else
        say(session.json.to_json)
      end
    end

  end
end
