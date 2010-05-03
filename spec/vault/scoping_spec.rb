require "spec_helper"

describe Vault do
  let :book_klass do
    model do
      scope :by_lewis_carroll do
        { :author => "Lewis Carroll" }
      end

      key :isbn
      property :title
      property :author
    end
  end

  let :alice_in_wonderland do
    book_klass.new(:isbn   => "978-0517223628",
                   :title  => "Alice in Wonderland",
                   :author => "Lewis Carroll")
  end

  let :through_the_looking_glass do
    book_klass.new(:isbn   => "978-0140367096",
                   :title  => "Through the Looking Glass",
                   :author => "Lewis Carroll")
  end

  let :the_wonderful_wizard_of_oz do
    book_klass.new(:isbn   => "978-0451530295",
                   :title  => "The Wonderful Wizard of Oz",
                   :author => "Lyman Frank Baum")
  end

  before do
    alice_in_wonderland.save
    through_the_looking_glass.save
    the_wonderful_wizard_of_oz.save
  end

  it "filters the collection by the given scope" do
    scoped = book_klass.by_lewis_carroll
    scoped.all.should have(2).elements
  end
end
