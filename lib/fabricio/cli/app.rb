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
      if options[:short]
        apps = client.app.all
        say(apps.map {|app| app.pretty_print}.join("\n\n"))
      else
        say("#{client.app.all}")
      end
    end

    desc "get", "Obtain single app"
    option :app_id => :required, :type => :string
    option :short, :type => :boolean
    def get(app_id)
      if options[:short]
        say("#{client.app.get(app_id).pretty_print}")
      else
        say("#{client.app.get(app_id).to_s}")
      end
    end

    desc "active_now", "Obtain active now count"
    option :app_id => :required, :type => :string
    def active_now(app_id)
      if options[:short]
        say("#{client.app.active_now(app_id).pretty_print}")
      else
        say("#{client.app.active_now(app_id).to_s}")
      end
    end

    desc "single_issue", "Obtain issue by external_id"
    option :app_id => :required, :type => :string
    option :external_id => :required, :type => :string
    def issue(app_id, external_id)
      if options[:short]
        say("#{client.app.single_issue(app_id, external_id).pretty_print}")
      else
        say("#{client.app.single_issue(app_id, external_id).to_s}")
      end
    end

    desc "issue_session", "Obtain session"
    option :app_id => :required, :type => :string
    option :external_id => :required, :type => :string
    option :session_id => :required, :type => :string
    def session(app_id, external_id, session_id)
      if options[:short]
        say("#{client.app.issue_session(app_id, external_id, session_id).pretty_print}")
      else
        say("#{client.app.issue_session(app_id, external_id, session_id).to_s}")
      end
    end

    desc "latest_session", "Obtain latest issue session"
    option :app_id => :required, :type => :string
    option :external_id => :required, :type => :string
    def latest_session(app_id, external_id)
      if options[:short]
        say("#{client.app.issue_session(app_id, external_id).pretty_print}")
      else
        say("#{client.app.issue_session(app_id, external_id).to_s}")
      end
    end

  end
end
