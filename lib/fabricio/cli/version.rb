require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'cli_helper'

module Fabricio
  class Version < Thor

    desc "all", "Obtain all versions"
    option :app_id => :required, :type => :string
    option :short, :type => :boolean
    def all(app_id)
      if options[:short]
        say("#{client.version.all(app_id)}")
      else
        say("#{client.version.all(app_id).to_s}")
      end
    end

    desc "top", "Obtain single build"
    option :app_id => :required, :type => :string
    option :start_time, :type => :string
    option :end_time, :type => :string
    option :short, :type => :boolean
    def top(app_id)
      result = nil
      if options[:start_time] && options[:end_time]
        result = client.version.top(app_id, options[:start_time], options[:end_time])
      else
        result = client.version.top(app_id)
      end
      if options[:short]
        say("#{client.version.top(app_id).pretty_print}")
      else
        say("#{client.version.top(app_id).to_s}")
      end
    end

  end
end
