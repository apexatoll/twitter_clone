require 'rails_helper'

RSpec.describe User, type: :model do
  describe "creating a user" do
    def create(name:nil, email:nil)
      User.new(name:name, email:email)
    end
    describe "field presence" do
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
    describe "field value length" do
      let(:max_name){ 50 }
      let(:max_email){ 255 }
      context "name is longer than maximum characters" do
        it "is invalid" do
          name = "a" * (max_name + 1)
          expect(name.length).to eq(51)
          user = create(name:name, email:"test@test.com")
          expect(user.valid?).to_not be(true)
        end
      end
      context "email is longer than maximum characters" do
        def email
          post  = "@test.com"
          "#{"a" * (max_email - (post.length) + 1)}#{post}"
        end
        it "is invalid" do
          expect(email.length).to eq(256)
          user = create(name:"test", email:email)
          expect(user.valid?).to_not be(true)
        end
      end
    end
  end
end
