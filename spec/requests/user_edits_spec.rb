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
    context "unsuccessful edit" do
      let(:user_params) do
        {
          user: {
            name: "",
            email: "foo@invalid",
            password:" foo",
            password_confirmation: "bar"
          }
        }
      end
      before{ patch user_path(user), params:user_params }
      it "renders the edit form" do
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
  end
end
