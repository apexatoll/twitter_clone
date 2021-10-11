require 'rails_helper'

RSpec.describe "User sign up", type: :request do
  it "renders the correct view" do
    expect(get signup_path).to render_template("users/new")
  end
  context "when invalid sign up data passed" do
    let(:invalid_user) do
      {     
        name: "",
        email: "invalid.com",
        password: 1234,
        password_confirmation:123
      }
    end
    it "does not create the user" do
      expect do
        post users_path, params:{ user:invalid_user }
      end.to_not change{ User.count }
    end
  end
end
