require 'simplecov'
require 'helpers/cli_executor'

SimpleCov.start do
  add_group('Authorization', 'lib/fabricio/authorization')
  add_group('Client', 'lib/fabricio/client')
  add_group('Networking', 'lib/fabricio/networking')
  add_group('Service', 'lib/fabricio/service')
  add_group('Models', 'lib/fabricio/models')
  add_group('CLI', 'lib/fabricio/cli')
  add_filter('spec')
  add_filter('fabricio.rb')
end

require "fabricio"
