require "spec_helper"

describe Vault do
  let :book_klass do
    model do
      key      :isbn
      property :title
    end
  end

  it "can initialize a new model from a hash of attributes" do
    book = book_klass.new(:title => "Some Book", :isbn => "1234567890")
    book.title.should == "Some Book"
    book.isbn.should  == "1234567890"
  end

  describe "#update" do
    let :book do
      book_klass.new(:title => "Some Book", :isbn => "1234567890")
    end

    it "effectively changes the attribute values" do
      book.update(:title => "Awesome Book", :isbn => "0987654321")
      book.title.should == "Awesome Book"
      book.isbn.should  == "0987654321"
    end

    it "flags attributes as changed when bulk-updating" do
      book.update(:title => "Awesome Book")
      book.changes.should include(:title)
    end
  end
end
