require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    let(:valid_user){ User.new(name:"test", email:"a@b.com") }
    def user_with_name_valid?(name)
      valid_user.tap{|u| u.name = name}.valid?
    end
    def user_with_email_valid?(email)
      valid_user.tap{|u| u.email = email}.valid?
    end
    context "when valid data passed" do
      it "returns true" do
        expect(valid_user.valid?).to be(true)
      end
    end
    describe "field presence" do
      context "when name is omitted" do
        it "returns false" do
          expect(user_with_email_valid?(nil)).to be(false)
        end
      end
      context "when email is omitted" do
        it "returns false" do
          expect(user_with_name_valid?(nil)).to be(false)
        end
      end
    end
    describe "field value length" do
      let(:max_name){ 50 }
      let(:max_email){ 255 }
      context "name is longer than maximum characters" do
        it "returns false" do
          name = "a" * (max_name + 1)
          expect(name.length).to eq(51)
          expect(user_with_name_valid?(name)).to be(false)
        end
      end
      context "email is longer than maximum characters" do
        def email
          post  = "@test.com"
          "#{"a" * (max_email - (post.length) + 1)}#{post}"
        end
        it "returns false" do
          expect(email.length).to eq(256)
          expect(user_with_email_valid?(email)).to be(false)
        end
      end
    end
    describe "email validity" do
      let(:user){ User.new(name:"test", email:"test@t.com") }
      context "when email is in correct format" do
        def valid_emails
          [
           "test@test.com", 
           "another-test@test.com", 
           "TEST@TEST.foo.com", 
           "test@foo.jp", 
           "foo+bar@baz.com"
          ]
        end
        it "returns true" do
          valid_emails.each do |email|
            expect(user_with_email_valid?(email)).to be(true),
              "valid address #{email} fails"
          end
        end
      end
      context "when email is in invalid format" do
        def invalid_emails
          [
            "test@test,com", 
            "test_at_test.com", 
            "test@testcom",
            "test@foo_bar.com", 
            "foo@bar+baz.com"
          ]
        end
        it "returns false" do
          invalid_emails.each do |email|
            expect(user_with_email_valid?(email))
              .to be(false), 
              "invalid address #{email} passes"
          end
        end
      end
    end
    describe "email uniqueness" do
      context "when duplicate email passed" do
        context "and identical casing" do
          it "returns false" do
            duplicate = valid_user.dup
            valid_user.save
            expect(duplicate.valid?).to be(false)
          end
        end
        context "and different casing" do
          it "returns false" do
            duplicate = valid_user.dup
              .tap{|u| u.email.upcase! }
            valid_user.save
            expect(duplicate.valid?).to be(false)
          end
        end
      end
    end
  end
  describe "#save" do
    describe "email addressess should be case insensitive" do
      context "when variable case email is passed" do
        it "saves as lowercase" do
          email = "TesT@TEst.COM"
          user  = User.new(name:"test", email:email)
          expect(user.tap{|u| u.save}.email)
            .to eql(email.downcase)
        end
      end
    end
  end
end
