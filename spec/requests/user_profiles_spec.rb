require 'rails_helper'

RSpec.describe "User Profiles", type: :request do
  include ApplicationHelper
  describe "GET /users/:id" do
    fixtures :users
    let(:user){ users(:admin) }
    before{ get user_path(user) }
    it "renders the correct template" do
      expect(response).to render_template("users/show")
    end
    it "displays the correct title" do
      assert_select "title", full_title(user.name)
    end
    describe "page elements" do
      it "contains an h1 with the users name" do
        assert_select "h1", text:user.name
      end
      it "has an embedded avatar within the h1" do
        assert_select "h1>img.avatar"
      end
      it "displays the users micropost count" do
        expect(response.body).to match(user.microposts.count.to_s)
      end
      it "contains pagination element" do
        assert_select "div.pagination", count: 1
      end
      it "displays the users microposts" do
        user.microposts.paginate(page:1).each do |m|
          expect(response.body).to match(m.content)
        end
      end
    end
  end
end
