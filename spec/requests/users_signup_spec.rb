require 'rails_helper'

RSpec.describe "User sign up", type: :request do
  describe "GET /signup" do
    it "renders the correct view" do
      expect(get signup_path).to render_template("users/new")
    end
  end
  describe "POST /users" do
    context "when invalid sign up data passed" do
      let(:invalid_user) do
        {     
          name: "",
          email: "invalid.com",
          password: 1234,
          password_confirmation:123
        }
      end
      def signup
        post users_path, params:{ user:invalid_user }
      end
      it "does not create the user" do
        expect{ signup }.to_not change{ User.count }
      end
      it "responds with 200" do
        signup
        expect(response.status).to eq(200)
      end
      it "renders the signup page" do
        signup
        expect(response).to render_template("users/new")
      end
      it "shows errors" do
        signup
        assert_select "#error_explanation"
      end
    end
    context "when valid sign up data passed" do
      before(:all){ ActionMailer::Base.deliveries.clear }
      let(:valid_user) do
        {
          name:"Example",
          email:"eg@eg.com",
          password:"123456",
          password_confirmation:"123456"
        }
      end
      def signup
        post users_path, params:{ user:valid_user }
      end
      it "creates a new user" do
        expect{ signup }.to change{ User.count }.by(1)
      end
      it "responds with a redirect" do
        signup
        expect(response.status).to eq(302)
      end
      it "does not activate the user" do
        signup
        expect(User.last.activated?).to be(false)
      end
      it "sends an email" do
        signup
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
      it "does not login the user" do
        signup
        expect(is_logged_in?).to be(false)
      end
      it "shows an info flash" do
        signup
        expect(flash[:info]).to_not be_nil
      end
      describe "account activation" do
        before{ signup }
        let(:user){ assigns(:user) }
        context "when following invalid activation token" do
          before do
            get edit_account_activation_path("invalid", email:user.email)
          end
          it "does not activate the user" do
            expect(user.reload.activated?).to_not be(true)
          end
          it "redirects to the homepage" do
            expect(response).to redirect_to(root_url)
          end
          it "shows an error flash" do
            expect(flash[:danger]).to_not be_nil
          end
          it "does not log the user in" do
            expect(is_logged_in?).to be(false)
          end
        end
        context "with valid activation token and invalid email" do
          before do
            get edit_account_activation_path(user.activation_token, email:"invalid")
          end
          it "does not activate the user" do
            expect(user.reload.activated?).to be(false)
          end
          it "redirects to the homepage" do
            expect(response).to redirect_to(root_url)
          end
          it "does not log the user in" do
            expect(is_logged_in?).to be(false)
          end
          it "shows an error flash" do
            expect(flash[:danger]).to_not be_nil
          end
        end
        context "with valid activation token and valid email" do
          before do
            get edit_account_activation_path(user.activation_token, email:user.email)
          end
          it "activates the user" do
            expect(user.reload.activated?).to be(true)
          end
          it "redirects to the user page" do
            expect(response).to redirect_to(user)
          end
          it "logs the user in" do
            expect(is_logged_in?).to be(true)
          end
          it "shows a success flash" do
            expect(flash[:success]).to_not be_nil
          end
        end
      end
    end
  end
end
