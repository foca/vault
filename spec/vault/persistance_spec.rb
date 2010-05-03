require "spec_helper"

describe Vault do
  let :book_klass do
    model do
      key :isbn
      property :title
      property :author
    end
  end

  let :store do
    book_klass.store
  end

  let :alice do
    book_klass.new("title"  => "Alice in Wonderland",
                   "author" => "Lewis Carroll",
                   "isbn"   => "978-0862033248")
  end

  describe "#save" do
    it "returns true" do
      alice.save.should be(true)
    end

    it "marks the object as persisted" do
      alice.save
      alice.should be_persisted
    end

    it "stores the object in the model's store" do
      alice.save
      store[alice.isbn].should include("title", "author")
    end

    it "doesn't store the key among the object properties" do
      alice.save
      store[alice.isbn].should_not include("isbn")
    end

    it "updates an already saved object's attributes" do
      alice.save
      alice.update(:title => "Alice in Wonderland Illustrated")
      alice.save

      store[alice.isbn]["title"].should == "Alice in Wonderland Illustrated"
    end

    it "clears the tracked changed attributes" do
      alice.save
      alice.should_not be_changed
    end

    it "doesn't keep the old key when you change it" do
      alice.save
      alice.update("isbn" => "978-0517223628")
      old_isbn = alice.isbn_was
      alice.save

      store[old_isbn].should be_blank
      store[alice.isbn].should_not be_blank
    end

    context "when the object is invalid" do
      let :person_klass do
        named_model :Person do
          key      :email
          property :name

          validates :email, :presence => true
          validates :name,  :presence => true
        end
      end

      let :store do
        person_klass.store
      end

      let :nameless_person do
        person_klass.new(:email => "john.doe@example.org")
      end

      it "returns false" do
        nameless_person.save.should be(false)
      end

      it "doesn't persist the object" do
        nameless_person.save
        nameless_person.should_not be_persisted
      end

      context "but you skip validations" do
        it "returns true" do
          nameless_person.save(false).should be(true)
        end

        it "persists the object anyway" do
          nameless_person.save(false)
          nameless_person.should be_persisted
        end
      end
    end
  end

  describe "#destroy" do
    before do
      alice.save
    end

    it "should no longer be persisted after being destroyed" do
      alice.destroy
      alice.should_not be_persisted
    end

    it "removes the object from the model's store" do
      alice.destroy
      store[alice.isbn].should be_blank
    end

    it "freezes the model" do
      alice.destroy
      alice.should be_frozen
    end
  end
end
