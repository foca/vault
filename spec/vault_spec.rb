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
end
