require "spec_helper"

describe "ActiveModel compliance" do
  class Person
    include Vault

    key      :id
    property :first_name
    property :last_name
  end

  include ActiveModel::Lint::Tests

  instance_methods.grep(/^test_/).each do |method|
    it method.gsub("_", " ").gsub(/to (\w+)/, 'to_\1') do
      send method
    end
  end

  private

  def model
    Person.new
  end

  def assert(cond, msg=nil)
    flunk msg unless cond
  end

  def assert_kind_of(kind, object, msg=nil)
    flunk msg unless object.kind_of?(kind)
  end
end
