require 'rails_helper'

RSpec.describe "User edits", type: :request do
  fixtures :users
  before do 
    @user = users(:example)
    @other_user = users(:another)
  end
  describe "GET /user/:id" do
    context "when logged in" do
      context "as correct user" do
        before do 
          log_in_as @user
          get edit_user_path(@user)
        end
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
      context "as incorrect user" do
        before do 
          log_in_as @other_user
          get edit_user_path(@user)
        end
        it "redirects to root" do
          expect(response).to redirect_to(root_url)
        end
        it "does not show an error" do
          expect(flash[:danger]).to be_nil
        end
      end
    end
    context "when not logged in" do
      before do
        get edit_user_path(@user)
      end
      it "redirects to login page" do
        expect(response).to redirect_to(login_path)
      end
      it "shows an error message" do
        expect(flash[:danger]).to_not be_empty
      end
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
    context "when logged in" do
      before{ log_in_as @user }
      context "unsuccessful edit" do
        let(:user_params) do
          user_with_params(
            name:"", email:"foo@invalid", 
            password:"foo", password_confirmation:"bar")
        end
        before{ patch user_path(@user), params:user_params }
        it "rerenders the edit form" do
          expect(response).to render_template("users/edit")
        end
        it "renders the correct number of errors" do
          assert_select "div.alert", 
            text: "The form contains 4 errors."
        end
        it "does not change the database" do
          name, email = @user.name, @user.email
          @user.reload
          expect(@user.name).to eq(name)
          expect(@user.email).to eq(email)
        end
      end
      context "successful edit" do
        before{ patch user_path(@user), params:user_with_params }
        it "renders a flash message" do
          expect(flash[:success]).to_not be_empty
        end
        it "redirects to the user page" do
          expect(response).to redirect_to(@user)
        end
        it "updates the user information" do
          @user.reload
          expect(@user.name).to eql("Updated Name")
          expect(@user.email).to eql("foo@bar.com")
        end
      end
    end
    context "when logged in as wrong user" do
      before do
        log_in_as @other_user
        patch user_path(@user), params:user_params
      end
      let(:user_params) do
        user_with_params(
          name:"Updated Name", email:"foo@bar.com")
      end
      it "redirects to root" do
        expect(response).to redirect_to(root_url)
      end
      it "does not change the database" do
        name, email = @user.name, @user.email
        @user.reload
        expect(@user.name).to eql(name)
        expect(@user.email).to eql(email)
      end
      it "shows no errors" do
        expect(flash[:danger]).to be_nil
      end
    end
    describe "friendly forwarding" do
      it "redirects to previous page" do
        get edit_user_path(@user)
        log_in_as(@user)
        expect(response).to redirect_to(edit_user_url(@user))
      end
    end
  end
end
