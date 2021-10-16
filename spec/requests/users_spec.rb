require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET /users/:id/edit" do
    fixtures :users
    let(:user){ users(:example) }
    context "when logged in" do
      before{ log_in_as(user) }
      it "renders the user edit template" do
        get edit_user_path(user) 
        expect(response).to render_template("users/edit")
      end
    end
    context "when not logged in" do
      it "redirects to the login page" do
        get edit_user_path(user)
        expect(response).to redirect_to(login_url)
      end
    end
  end
  describe "PATCH /users/:id" do
    context "when logged in" do
      pending
    end
    context "when not logged in" do
      pending
    end
  end
  describe "GET /users" do
    context "when not logged in" do
      it "redirects to login page" do
        get users_path
        expect(response).to redirect_to(login_url)
      end
    end
    context "when logged in"
  end
end
