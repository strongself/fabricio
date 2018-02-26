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
      hash = prepared_options(options)
      say("#{client.version.all(hash).to_json}")
    end

    desc "top", "Obtain top versions"
    option :org_id, :type => :string
    option :app_id, :type => :string
    option :start_time, :type => :string
    option :end_time, :type => :string
    option :short, :type => :boolean
    def top
      hash = prepared_options(options)
      versions = client.version.top(hash)
      if options[:short]
        say("#{versions.pretty_print}")
      else
        say("#{versions}")
      end
    end

  end
end
