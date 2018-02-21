require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'cli_helper'

module Fabricio
  class Version < Thor

    desc "all", "Obtain all versions"
    option :app_id, :type => :string
    def all
      say("#{client.version.all(options[:app_id]).to_json}")
    end

    desc "top", "Obtain top versions"
    option :app_id, :type => :string
    option :start_time, :type => :string
    option :end_time, :type => :string
    option :short, :type => :boolean
    def top
      result = nil
      if options[:start_time] && options[:end_time]
        result = client.version.top(options[:app_id], options[:start_time], options[:end_time])
      else
        result = client.version.top(options[:app_id])
      end
      if options[:short]
        say("#{result.pretty_print}")
      else
        say("#{result}")
      end
    end

  end
end
