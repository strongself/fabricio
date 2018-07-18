require 'rspec'
require 'fabricio/authorization/file_session_storage'
require 'fabricio/authorization/file_param_storage'

describe 'FileParamStorage' do
  let(:path) { '/path/to/params.yml' }
  let(:yaml) do
    yaml = <<-YAML
    organization_id: my_organization
    app_id: my_app
    YAML
    YAML.load(yaml)
  end

  before(:each) do
    allow(YAML).to receive(:load_file).with(path).and_return(yaml)
    allow(File).to receive(:exist?).with(path).and_return(true)
    @storage = Fabricio::Authorization::FileParamStorage.new(path)
  end

  describe '#organization_id' do
    it { expect(@storage.organization_id).to eq('my_organization') }
  end

  describe '#app_id' do
    it { expect(@storage.app_id).to eq('my_app') }
  end
end

