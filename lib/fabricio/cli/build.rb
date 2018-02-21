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
      builds = client.build.all(options[:org_id], options[:app_id])
      if options[:short]
        say(builds.map {|build| build.pretty_print}.join("\n\n"))
      else
        say(builds.map { |build| build.json }.to_json)
      end
    end

    desc "get", "Obtain single build"
    option :org_id, :type => :string
    option :app_id, :type => :string
    option :version => :required, :type => :string
    option :build_number => :required, :type => :string
    option :short, :type => :boolean
    def get(version, build_number)
      build = client.build.get(options[:org_id], options[:app_id], version, build_number)
      if options[:short]
        say(build.pretty_print)
      else
        say(build.json.to_json)
      end
    end

  end
end
