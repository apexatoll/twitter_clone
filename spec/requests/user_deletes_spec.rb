require 'rails_helper'

RSpec.describe "User Delete", type: :request do
  describe "DELETE /users/:id" do
    fixtures :users
    before do
      @admin = users(:admin)
      @non_admin = users(:example)
    end
    context "when not logged in" do
      it "redirects to login page" do
        delete user_path(@non_admin) 
        expect(response).to redirect_to(login_path)
      end
      it "does not delete the user" do
        expect{ delete user_path(@non_admin) }
          .to_not change{ User.count }
      end
    end
    context "when logged in as non-admin" do
      before{ log_in_as @non_admin }
      it "does not delete user" do
        expect{ delete user_path(@non_admin) }
          .to_not change{ User.count }
      end
      it "redirects to home page" do
        delete user_path(@non_admin)
        expect(response).to redirect_to(root_path)
      end
    end
    context "when logged in as admin" do
      before{ log_in_as @admin }
      it "deletes the user" do
        expect{ delete user_path(@non_admin) }
          .to change{ User.count }.by(-1)
      end
      it "rerenders the users index" do
        delete user_path(@non_admin)
        expect(response).to redirect_to(users_url)
      end
    end
  end
end
