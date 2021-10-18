require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    User.new(name:"test", email:"a@b.com", 
             password:"foobar", password_confirmation:"foobar")
  end
  describe "#valid?" do
    context "when valid data passed" do
      it "returns true" do
        expect(subject.valid?).to be(true)
      end
    end
    describe "field presence" do
      context "when name is omitted" do
        it "returns false" do
          expect(is_user_with_this_email_valid?(nil)).to be(false)
        end
      end
      context "when email is omitted" do
        it "returns false" do
          expect(is_user_with_this_name_valid?(nil)).to be(false)
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
          expect(is_user_with_this_name_valid?(name)).to be(false)
        end
      end
      context "email is longer than maximum characters" do
        def email
          post  = "@test.com"
          "#{"a" * (max_email - (post.length) + 1)}#{post}"
        end
        it "returns false" do
          expect(email.length).to eq(256)
          expect(is_user_with_this_email_valid?(email)).to be(false)
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
            expect(is_user_with_this_email_valid?(email)).to be(true),
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
            expect(is_user_with_this_email_valid?(email))
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
            duplicate = subject.dup
            subject.save
            expect(duplicate.valid?).to be(false)
          end
        end
        context "and different casing" do
          it "returns false" do
            duplicate = subject.dup
              .tap{|u| u.email.upcase! }
            subject.save
            expect(duplicate.valid?).to be(false)
          end
        end
      end
    end
    describe "password security" do
      let(:password_valid){ is_user_with_this_password_valid?(password) }
      context "when password is >= 6 characters" do
        let(:password){ "a" * 6 }
        it "returns true" do
          expect(password_valid).to be(true)
        end
      end
      context "when password is < 6 characters" do
        let(:password){ "a" * 5 }
        it "returns false" do
          expect(password_valid).to be(false)
        end
      end
      context "when password is blank" do
        let(:password){ " " * 6 }
        it "returns false" do
          expect(password_valid).to be(false)
        end
      end
    end
    def is_user_with_this_name_valid?(name)
      subject.tap{|u| u.name = name}.valid?
    end
    def is_user_with_this_email_valid?(email)
      subject.tap{|u| u.email = email}.valid?
    end
    def is_user_with_this_password_valid?(password)
      subject.tap do |u| 
        u.password = u.password_confirmation = password
      end.valid?
    end
  end
  describe "#save" do
    describe "email addressess should be case insensitive" do
      context "when variable case email is passed" do
        it "saves as lowercase" do
          email = "TesT@TEst.COM"
          user  = subject.tap{|u| u.email = email}
          expect(user.tap{|u| u.save}.email)
            .to eql(email.downcase)
        end
      end
    end
  end
  describe "#authenticated?" do
    it "returns false for a user with digest set to nil" do
      expect(subject.authenticated?(:remember, "")).to be(false)
    end
  end
  describe "#destroy" do
    it "deletes associated microposts" do
      subject.save
      subject.microposts.create!(content: "Lorem ipsum")
      expect{ subject.destroy }.to change{ Micropost.count }.by(-1)
    end
  end
end
