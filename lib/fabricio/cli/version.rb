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
    option :org_id, :type => :string
    option :app_id, :type => :string
    option :start, :type => :string
    option :end, :type => :string
    option :short, :type => :boolean
    def top
      result = nil
      if options[:start] && options[:end]
        result = client.version.top(options[:org_id], options[:app_id], options[:start], options[:end])
      else
        result = client.version.top(options[:org_id])
      end
      if options[:short]
        say("#{result.pretty_print}")
      else
        say("#{result}")
      end
    end

  end
end
