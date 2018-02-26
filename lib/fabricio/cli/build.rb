require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'cli_helper'

module Fabricio
  class Build < Thor

    desc "all", "Obtain all builds"
    option :org_id, :type => :string
    option :app_id, :type => :string
    option :short, :type => :boolean
    def all
      hash = prepared_options(options)
      builds = client.build.all(hash)
      if options[:short]
        say(builds.map {|build| build.pretty_print}.join("\n\n"))
      else
        say(builds.map { |build| build.json }.to_json)
      end
    end

    desc "get", "Obtain single build"
    option :org_id, :type => :string
    option :app_id, :type => :string
    option :version, :type => :string
    option :build_number, :type => :string
    option :short, :type => :boolean
    def get
      hash = prepared_options(options)
      build = client.build.get(hash)
      if options[:short]
        say(build.pretty_print)
      else
        say(build.json.to_json)
      end
    end

  end
end
