require 'rails_helper'

RSpec.describe User, type: :model do
  describe "creating a user" do
    def create(name:nil, email:nil)
      User.new(name:name, email:email)
    end
    describe "testing field presence" do
      context "when name and email present" do
        it "is valid" do
          user = create(name:"example", email:"a@b.com")
          expect(user.valid?).to be(true)
        end
      end
      context "when name is omitted" do
        it "is invalid" do
          user = create(email:"a@b.com")
          expect(user.valid?).to_not be(true)
        end
      end
      context "when email is omitted" do
        it "is invalid" do
          user = create(name:"example")
          expect(user.valid?).to_not be(true)
        end
      end
    end
  end
end
