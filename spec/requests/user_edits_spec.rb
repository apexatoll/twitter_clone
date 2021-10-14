require 'rails_helper'

RSpec.describe "User edits", type: :request do
  fixtures :users
  let(:user) do 
    users(:example)
  end

  describe "GET /user/:id" do
    before{ get edit_user_path(user) }
    it "responds with 200" do
      expect(response.status).to eq(200)
    end
    it "renders the right template" do
      expect(response).to render_template("users/edit")
    end
    it "populates the name input" do
      assert_select "input[name=?]", "user[name]", value: "Example User"
    end
    it "populates the email input" do
      assert_select "input[name=?]", "user[name]", value: "user@example.com"
    end
    it "does not populate the password fields" do
      assert_select "input[name=?]", "user[password]", value:nil
      assert_select "input[name=?]", "user[password_confirmation]", value:nil
    end
  end

  describe "PATCH /user/:id" do
    def user_with_params(name:"Updated Name", email:"foo@bar.com", password:"", password_confirmation:"")
      {
        user: {
          name: name,
          email: email,
          password: password,
          password_confirmation: password_confirmation
        }
      }
    end
    context "unsuccessful edit" do
      let(:user_params) do
        user_with_params(
          name:"", email:"foo@invalid", 
          password:"foo", password_confirmation:"bar")
      end
      before{ patch user_path(user), params:user_params }
      it "rerenders the edit form" do
        expect(response).to render_template("users/edit")
      end
      it "renders the correct number of errors" do
        assert_select "div.alert", 
          text: "The form contains 4 errors."
      end
      it "does not change the database" do
        name, email = user.name, user.email
        user.reload
        expect(user.name).to eq(name)
        expect(user.email).to eq(email)
      end
    end
    context "successful edit" do
      before{ patch user_path(user), params:user_with_params }
      it "renders a flash message" do
        expect(flash[:success]).to_not be_empty
      end
      it "redirects to the user page" do
        expect(response).to redirect_to(user)
      end
      it "updates the user information" do
        user.reload
        expect(user.name).to eql("Updated Name")
        expect(user.email).to eql("foo@bar.com")
      end
    end
  end
end
