require "spec_helper"

describe Vault, "model" do
  class Book
    include Vault
    key      :title
    has_many :authors
  end

  class Author
    include Vault
    key        :name
    belongs_to :book
  end

  let(:pickaxe_book) { Book.new(:title => "Programming Ruby") }

  let(:dave_thomas)  { Author.new(:name => "Dave Thomas") }
  let(:chad_fowler)  { Author.new(:name => "Chad Fowler") }
  let(:andy_hunt)    { Author.new(:name => "Andy Hunt")   }
  let(:sam_ruby)     { Author.new(:name => "Sam Ruby")    }

  describe ".belongs_to" do
    before do
      dave_thomas.save
      pickaxe_book.save
    end

    it "can assign the associated object directly" do
      dave_thomas.book = pickaxe_book
      dave_thomas.book.should == pickaxe_book
    end

    it "can assign the key" do
      dave_thomas.book_key = pickaxe_book.key
      dave_thomas.book.should == pickaxe_book
    end
  end

  describe ".has_many" do
    before do
      dave_thomas.book = pickaxe_book
      chad_fowler.book = pickaxe_book

      dave_thomas.save
      chad_fowler.save

      pickaxe_book.save
    end

    subject { pickaxe_book.authors.all }

    it "can find all associated objects" do
      should include(dave_thomas, chad_fowler)
    end

    it "doesn't find objects that haven't been associated to the model" do
      should_not include(sam_ruby)
    end

    context "adding objects directly to the association" do
      it "persists both the container and containee" do
        pickaxe_book.authors << andy_hunt
        should include(andy_hunt)
      end

      it "can chain additions" do
        pickaxe_book.authors << andy_hunt << sam_ruby
        should include(andy_hunt, sam_ruby)
      end
    end
  end
end
