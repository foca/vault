require "spec_helper"

describe Vault do
  let :person_klass do
    model do
      key :name
      property :email
      property :age
    end
  end

  let :john do
    person_klass.new(:name => "John", :email => "john@example.org", :age => 28)
  end

  let :mary do
    person_klass.new(:name => "Mary", :email => "mary@example.org", :age => 23)
  end

  let :bob do
    person_klass.new(:name => "Bob", :email => "bob@example.org", :age => 29)
  end

  let :jane do
    person_klass.new(:name => "Jane", :email => "jane@example.org", :age => 28)
  end

  before do
    john.save
    mary.save
    bob.save
    jane.save
  end

  describe "#all" do
    subject { person_klass.all }

    it { should have(4).elements }

    it "includes all the persisted objects" do
      should include(john)
      should include(mary)
      should include(bob)
      should include(jane)
    end

    it { should be_an(Enumerable) }
  end

  describe "#find" do
    it "finds an object by key" do
      person_klass.find("Bob").should == bob
    end

    it "returns nil if it doesn't find it" do
      person_klass.find("Jamie").should be_nil
    end
  end

  describe "#count" do
    it "returns the amount of elements in the store" do
      person_klass.count.should == 4
    end

    it "is aliased to #size" do
      person_klass.size.should == person_klass.count
    end
  end
end
