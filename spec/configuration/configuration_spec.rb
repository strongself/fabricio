require 'rspec'
require 'fabricio/configuration/configuration'

describe 'Configuration' do

  it 'should have default values for options' do
    Fabricio::Configuration::VALID_OPTIONS_KEYS.each do |key|
      result = Fabricio.send(key)
      expect(result).to equal(Fabricio::Configuration.const_get("DEFAULT_#{key.upcase}"))
    end
  end

  it 'should configure values in block' do
    test_value = '123'
    Fabricio.configure do |config|
      Fabricio::Configuration::VALID_OPTIONS_KEYS.each do |key|
        config.send("#{key}=",test_value)
      end
    end

    Fabricio::Configuration::VALID_OPTIONS_KEYS.each do |key|
      result = Fabricio.send(key)
      expect(result).to equal(test_value)
    end
  end

  it 'should reset values' do
    test_value = '123'
    Fabricio.configure do |config|
      Fabricio::Configuration::VALID_OPTIONS_KEYS.each do |key|
        config.send("#{key}=",test_value)
      end
    end

    Fabricio.reset

    Fabricio::Configuration::VALID_OPTIONS_KEYS.each do |key|
      result = Fabricio.send(key)
      expect(result).to equal(Fabricio::Configuration.const_get("DEFAULT_#{key.upcase}"))
    end
  end
end