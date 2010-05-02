require "spec_helper"

describe Vault, "defining properties" do
  it "defines accessors for each property" do
    person_klass = model do
      property :name
      property :age
    end

    person = person_klass.new
    person.should respond_to(:name, :name=, :age, :age=)
  end

  it "doesn't define duplicated properties" do
    person_klass = model do
      property :name
      property :name
    end

    person_klass.should have(1).properties
  end

  it "doesn't support more than one key" do
    person_klass = model do
      key :name
      key :age
    end

    person = person_klass.new(:name => "John", :age => 28)
    person.save
    person.to_key.should == [person.age]
  end

  it "can specify default values" do
    person_klass = model do
      property(:name) { "John" }
      property(:age)  { 28 }
    end

    person = person_klass.new
    person.name.should == "John"
    person.age.should  == 28
  end

  it "provides 'dirty' attribute tracking" do
    model.included_modules.should include(ActiveModel::Dirty)
  end
end
