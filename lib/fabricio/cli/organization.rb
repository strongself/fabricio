require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'cli_helper'

module Fabricio
  class Organization < Thor

    desc "get", "Get organization"
    option :short, :type => :boolean
    def get
      if options[:short]
        say(client.organization.get.pretty_print)
      else
        say("#{client.organization.get.to_s}")
      end
    end

  end
end
