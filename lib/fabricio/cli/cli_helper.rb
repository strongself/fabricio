require 'fabricio'
require 'fabricio/authorization/file_session_storage'
require 'fabricio/authorization/file_param_storage'
require 'fileutils'
require 'yaml'

def client
  session_storage = Fabricio::Authorization::FileSessionStorage.new()
  param_storage = Fabricio::Authorization::FileParamStorage.new()
  session = session_storage.obtain_session
  if session
    return Fabricio::Client.new do |config|
      config.session_storage = session_storage
      config.param_storage = param_storage
    end
  else
    credential = ask_credential
    return Fabricio::Client.new do |config|
      config.username = credential.email
      config.password = credential.password
      config.session_storage = session_storage
      config.param_storage = param_storage
    end
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
