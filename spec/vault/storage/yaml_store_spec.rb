require "spec_helper"
require "tempfile"

describe Vault::Storage::YamlStore do
  let :path do
    begin
      file = Tempfile.new("store.yml")
      file.path
    ensure
      file.close
    end
  end

  subject do
    described_class.new(path)
  end

  before do
    subject["key_a"] = { "attr_1" => "value_1", "attr_2" => "value_2" }
    subject["key_b"] = { "attr_3" => "value_3" }
  end

  it_should_behave_like "A storage adapter"

  it "serializes the file to disk on #flush" do
    subject.flush
    YAML.load_file(path).should include("key_a", "key_b")
  end
end
