require 'fabricio'
require 'fabricio/authorization/file_session_storage'
require 'fileutils'
require 'yaml'

def client
  email = ""
  password = ""
  sessionStorage = FileSessionStorage()
  session = sessionStorage.obtain_session
  ask_credential unless session

  client = Fabricio::Client.new do |config|
    config.session_storage = sessionStorage
    config.param_storage = FileParamStorage()
  end
end

def ask_credential
  say("We have to know you're email from fabric account")
  email = ask("email: ")
  say("Now we want your password. Do not be afraid, it is stored locally")
  password = ask("password: ", :echo => false)
  say("")
  Fabricio::Model::Credential.new(email, password)
end
