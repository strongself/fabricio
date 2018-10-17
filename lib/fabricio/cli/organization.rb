require 'thor'
require 'fabricio'
require 'fileutils'
require 'yaml'
require_relative 'cli_helper'

module Fabricio
  class Organization < Thor

    desc "all", "Get all organization"
    option :short, :type => :boolean
    def all
      organizations = client.organization.all
      if options[:short]
        say(organizations.map {|organization| organization.pretty_print}.join("\n\n"))
      else
        say(organizations.map { |organization| organization.json }.to_json)
      end
    end

    

  end
end
