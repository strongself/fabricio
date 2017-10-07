require "simplecov"
require "rspec"
SimpleCov.start do
  add_group('Authorization', 'lib/fabricio/unit_tests/authorization')
  add_group('Client', 'lib/fabricio/unit_tests/client')
  add_group('Networking', 'lib/fabricio/unit_tests/networking')
  add_group('Service', 'lib/fabricio/unit_tests/service')
  add_group('Models', 'lib/fabricio/unit_tests/models')
  add_filter('spec')
  add_filter('fabricio.rb')
end

RSpec.configure do |config|
  TEST_EMAIL_KEY = 'TEST_FABRICIO_EMAIL'
  TEST_PASSWORD_KEY = 'TEST_FABRICIO_PASSWORD'
  TEST_CLIENT_ID = 'TEST_CLIENT_ID'
  TEST_CLIENT_SECRET = 'TEST_CLIENT_SECRET'
end

require "fabricio"
