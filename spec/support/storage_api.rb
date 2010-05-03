shared_examples_for "A storage adapter" do
  it { should respond_to(:size) }
  it { should respond_to(:delete) }
  it { should respond_to(:[]) }
  it { should respond_to(:[]=) }

  it { should respond_to(:each) }
  it { should be_an(Enumerable) }
end
