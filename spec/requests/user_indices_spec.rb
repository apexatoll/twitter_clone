require 'rails_helper'

RSpec.describe "UserIndices", type: :request do
  fixtures :users
  before{ @user = users(:example) }
  describe "GET /users" do
    context "when logged in" do
      before do
        log_in_as @user
        get users_path
      end
      it "renders the correct template" do
        expect(response).to render_template("users/index")
      end
      it "contains pagination" do
        assert_select "div.pagination", count:2
      end
      it "contains links to each user" do
        User.paginate(page: 1).each do |user|
          assert_select "a[href=?]", user_path(user), text:user.name
        end
      end
    end
    context "when not logged in" do
      before{ get users_path }
      it "redirects to login page" do
        expect(response).to redirect_to login_path
      end
    end
  end
end
