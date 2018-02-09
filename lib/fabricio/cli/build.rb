require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'cli_helper'

module Fabricio
  class Build < Thor

    desc "all", "Obtain all builds"
    option :app_id => :required, :type => :string
    option :short, :type => :boolean
    def all(app_id)
      if options[:short]
        builds = client.build.all(app_id)
        say(builds.map {|build| build.pretty_print}.join("\n\n"))
      else
        say("#{client.build.all(app_id).to_s}")
      end
    end

    desc "get", "Obtain single build"
    option :app_id => :required, :type => :string
    option :version => :required, :type => :string
    option :build_number => :required, :type => :string
    option :short, :type => :boolean
    def get(app_id, version, build_number)
      if options[:short]
        say("#{client.build.get(app_id, version, build_number).pretty_print}")
      else
        say("#{client.build.get(app_id, version, build_number).to_s}")
      end
    end

  end
end
