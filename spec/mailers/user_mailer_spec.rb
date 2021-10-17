require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  fixtures :users
  describe "account_activation" do
    let(:mail){ UserMailer.account_activation(@user) }
    before do
      @user = users(:example)
        .tap{|u| u.activation_token = User.new_token}
    end
    it "sets the subject" do
      expect(mail.subject).to eq("Account activation")
    end
    it "is to the right address" do
      expect(mail.to).to eq([@user.email])
    end
    it "is from the right address" do
      expect(mail.from).to eq(["welhamm@gmail.com"])
    end
    describe "email body" do
      it "contains the user activation token" do
        expect(mail.body.encoded).to match(@user.activation_token)
      end
      it "contains the user email in escaped form" do
        expect(mail.body.encoded).to match(CGI.escape(@user.email))
      end
    end
  end
  describe "password_reset" do
    let(:mail){ UserMailer.password_reset(@user) }
    before do
      @user = users(:example)
        .tap{|u| u.reset_token = User.new_token}
    end
    it "sets the subject" do
      expect(mail.subject).to eq("Reset your password")
    end
    it "is from the right address" do
      expect(mail.from).to eq(["welhamm@gmail.com"])
    end
    it "is to the right address" do
      expect(mail.to).to eq([@user.email])
    end
    describe "email body" do
      it "contains the user reset token" do
        expect(mail.body.encoded).to match(@user.reset_token)
      end
      it "contains the user email in escaped form" do
        expect(mail.body.encoded).to match(CGI.escape(@user.email))
      end
    end
  end
end
