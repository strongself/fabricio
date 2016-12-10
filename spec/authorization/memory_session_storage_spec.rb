require 'rspec'
require 'fabricio/authorization/memory_session_storage'

describe 'MemorySessionStorage' do

  before(:each) do
    @storage = Fabricio::Authorization::MemorySessionStorage.new
  end

  it 'should store session' do
    mockSession = Object.new
    @storage.store_session(mockSession)

    result = @storage.obtain_session
    expect(result).to equal(mockSession)
  end

  it 'should have nil session on start' do
    result = @storage.obtain_session
    expect(result).to be_nil
  end

  it 'should reset session' do
    mockSession = Object.new
    @storage.store_session(mockSession)
    @storage.reset

    result = @storage.obtain_session
    expect(result).to be_nil
  end
end