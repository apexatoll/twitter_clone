require 'rails_helper'

RSpec.describe "Password Resets", type: :request do
  fixtures :users
  let(:user){ users(:example) }
  describe "GET /password_resets/new" do
    before{ get new_password_reset_path }
    it "renders the correct form" do
      expect(response).to render_template("password_resets/new")
    end
    it "shows a field for email" do
      assert_select("input[name=?]", "password_reset[email]")
    end
  end
  describe "POST /password_resets" do
    before(:all){ ActionMailer::Base.deliveries.clear }
    let(:params){ { password_reset:{ email:email } } }
    context "invalid email" do
      let(:email){ "invalid.com" }
      before(:each){ post password_resets_path, params:params }
      it "rerenders the password reset page" do
        expect(response).to render_template("password_resets/new")
      end
      it "shows an error" do
        expect(flash[:danger]).to_not be_nil
      end
    end
    context "valid email" do
      let(:email){ user.email }
      before(:each){ post password_resets_path, params:params }
      it "updates the users reset digest" do
        existing_digest = user.reset_digest
        expect(user.reload.reset_digest).to_not eq(existing_digest)
      end
      it "sends an email to the user" do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
      it "shows an info message" do
        expect(flash[:info]).to_not be_nil
      end
      it "redirects to the root page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end
  describe "GET /password_resets/:token/edit" do
    before(:each) do 
      post password_resets_path, params:{password_reset:{email:user.email}}
      @user = assigns(:user)
      get edit_password_reset_path(token, email:email)
    end
    context "wrong email, right token" do
      let(:email){ "" }
      let(:token){ @user.reset_token }
      it "redirects to the root page" do
        expect(response).to redirect_to(root_url)
      end
    end
    context "right email, wrong token" do
      let(:email){ @user.email }
      let(:token){ "invalid token" }
      it "redirects to the root page" do
        expect(response).to redirect_to(root_url)
      end
    end
    context "right email, right token" do
      let(:email){ @user.email }
      let(:token){ @user.reset_token }
      it "renders the password reset edit form" do
        expect(response).to render_template("password_resets/edit")
      end
      it "contains a hidden field containing the email" do
        assert_select "input[name=email][type=hidden][value=?]", @user.email
      end
      it "contains a password field" do
        assert_select "input[name=?][type=password]", "user[password]"
      end
      it "contains a password confirmation field" do
        assert_select "input[name=?][type=password]", "user[password_confirmation]"
      end
      context "expired token" do
        before do
          @user.update_attribute(:reset_sent_at, 3.hours.ago)
          get edit_password_reset_path(token, email:email)
        end
        it "redirects to new password reset" do
          expect(response).to redirect_to(new_password_reset_path)
        end
        it "displays an error flash" do
          expect(flash[:danger]).to_not be_nil
        end
        it "the error message contains the word expired" do
          expect(flash[:danger]).to include("expired")
        end
      end
      context "inactive user" do
        before do
          @user.toggle!(:activated)
          get edit_password_reset_path(token, email:email)
        end
        it "redirects to the root page" do
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end
  describe "PATCH /password_resets/:token" do
    before do
      post password_resets_path, params:{ password_reset:{email:user.email} }
      @user = assigns(:user)
      patch password_reset_path(@user.reset_token), params:params
    end
    let(:params) do
      { 
        email: @user.email,
        user:{
          password:password, 
          password_confirmation:password_confirmation 
        }
      }
    end
    context "invalid password and confirmation" do
      let(:password){ "foobar" }
      let(:password_confirmation){ "123456" }
      it "rerenders the edit password reset form" do
        expect(response).to render_template("password_resets/edit")
      end
      it "displays a form error" do
        assert_select "div#error_explanation"
      end
      it "does not login the user" do
        expect(is_logged_in?).to be(false)
      end
    end
    context "empty password" do
      let(:password){ "" }
      let(:password_confirmation){ "" }
      it "rerenders the edit password reset form" do
        expect(response).to render_template("password_resets/edit")
      end
      it "displays a form error" do
        assert_select "div#error_explanation"
      end
      it "does not login the user" do
        expect(is_logged_in?).to be(false)
      end
    end
    context "valid password and confirmation" do
      let(:password){ "123456" }
      let(:password_confirmation){ "123456" }
      it "logs in the user" do
        expect(is_logged_in?).to be(true)
      end
      it "shows a success flash" do
        expect(flash[:success]).to_not be_nil
      end
      it "updates the password" do
        @user.reload
        expect(@user.authenticate_password("123456")).to be_truthy
        expect(@user.authenticate_password("password")).to be(false)
      end
      it "redirects to the user page" do
        expect(response).to redirect_to(@user)
      end
      it "resets the reset_digest" do
        expect(@user.reload.reset_digest).to be_nil
      end
    end
  end
end
