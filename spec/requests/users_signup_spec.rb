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
    context "when valid sign up date passed" do
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
        expect(response.status).to eq(302)
      end
      describe "following redirect" do
        before do
          signup
          follow_redirect!
          expect(response.status).to eq(200)
        end
        it "renders the user show page" do
          expect(response).to render_template("users/show")
        end
        it "shows a success flash" do
          expect(flash[:success]).to_not be_empty
        end
        it "does not show any flash errors" do
          expect(flash[:errors]).to be_nil
        end
        it "signs the user in" do
          expect(is_logged_in?).to be(true)
        end
      end
    end
  end
end
