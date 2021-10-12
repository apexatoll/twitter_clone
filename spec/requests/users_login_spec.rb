require "rails_helper"

RSpec.describe "user login", type: :request do
  describe "GET /login" do
    before do
      get login_path
    end
    it "responds with 200" do
      expect(response.status).to eql(200)
    end
    it "renders the correct template" do
      expect(response).to render_template("sessions/new")
    end
    describe "the login form" do
      it "renders the email field" do
        assert_select "input[name='session[email]']"
      end
      it "renders the password field" do
        assert_select "input[name='session[password]']"
      end
    end
  end
  describe "POST /login" do
    context "when invalid login details are provided" do
      let(:invalid_credentials) do
        {
          email:"fake@fake.com",
          password:1234
        }
      end 
      before do
        post login_path, params:{ session:invalid_credentials }
      end
      it "re-renders the login page" do
        expect(response).to render_template("sessions/new")
      end
      it "renders an error flash" do
        expect(flash[:danger]).to_not be_empty
      end
      context "when moving to a different page" do
        it "does not persist the error flash" do
          get root_path
          expect(flash[:danger]).to be_nil
        end
      end
    end
    context "when valid login details are provided" do
      fixtures :users
      let(:user){ users(:example) }
      let(:credentials) do
        {
          email: user.email,
          password: 'password'
        }
      end
      let(:params){ { session:credentials } }

      before{ post login_path, params:params }

      it "redirects to user overview page" do
        expect(response).to redirect_to(user)
      end
      context "following redirect" do
        before{ follow_redirect! }
        it "renders the correct template" do
          expect(response).to render_template("users/show")
        end
        it "shows no login links" do
          assert_select "a[href=?]", login_path, count:0
        end
        it "shows logout links" do
          assert_select "a[href=?]", logout_path
        end
        it "shows user profile links" do
          assert_select "a[href=?]", user_path(user)
        end
      end
    end
  end
end
