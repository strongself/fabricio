require 'fabricio'
require 'fileutils'
require 'yaml'

# Constants
CREDENTIAL_DIRECTORY_PATH = "#{Dir.home}/.fabricio"
CREDENTIAL_FILE_PATH = "#{CREDENTIAL_DIRECTORY_PATH}/.credential"
FABRIC_GRAPHQL_API_URL = 'https://api-dash.fabric.io/graphql'

def client
  email = ""
  password = ""
  if File.file?(CREDENTIAL_FILE_PATH)
    credential = YAML.load_file(CREDENTIAL_FILE_PATH)
    email = credential['email']
    password = credential['password']
  else
    ask_credential
  end

  client = Fabricio::Client.new do |config|
    config.username = email
    config.password = password
  end
end

def create_credential_file(credential)
  FileUtils.mkdir_p(CREDENTIAL_DIRECTORY_PATH)
  credential_hash = {
      "email" => credential.email,
      "password" => credential.password
  }
  File.open(CREDENTIAL_FILE_PATH,'w') do |f|
    f.write credential_hash.to_yaml
  end
  say("Your credential in #{CREDENTIAL_FILE_PATH}")
end

def ask_credential
  say("We have to know you're email from fabric account")
  email = ask("email: ")
  say("Now we want your password. Do not be afraid, it is stored locally")
  password = ask("password: ", :echo => false)
  say("")
  Fabricio::Model::Credential.new(email, password)
end