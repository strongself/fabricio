require 'rspec'
require 'fabricio/authorization/abstract_session_storage'
require 'fabricio/authorization/session'

describe 'Storage' do

  it 'should throw exception on session save event' do
    storage = Fabricio::Authorization::AbstractSessionStorage.new
    expect {
      storage.store_session(nil)
    }.to raise_error(NotImplementedError)
  end

  it 'should throw exception on reset event' do
    storage = Fabricio::Authorization::AbstractSessionStorage.new
    expect {
      storage.reset
    }.to raise_error(NotImplementedError)
  end
end