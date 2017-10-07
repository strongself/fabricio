require "simplecov"
require "rspec"
SimpleCov.start do
  add_group('Authorization', 'lib/fabricio/authorization')
  add_group('Client', 'lib/fabricio/client')
  add_group('Networking', 'lib/fabricio/networking')
  add_group('Service', 'lib/fabricio/service')
  add_group('Models', 'lib/fabricio/models')
  add_filter('spec')
  add_filter('fabricio.rb')
end

RSpec.configure do |config|
  config.before(:example) {
    TEST_EMAIL_KEY = 'TEST_FABRICIO_EMAIL'
    TEST_PASSWORD_KEY = 'TEST_FABRICIO_PASSWORD'
    TEST_CLIENT_ID = 'TEST_CLIENT_ID'
    TEST_CLIENT_SECRET = 'TEST_CLIENT_SECRET'
  }
end

require "fabricio"
