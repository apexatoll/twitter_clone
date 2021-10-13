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
      it "logs in" do
        expect(is_logged_in?).to be(true)
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
    context "when valid email but invalid password" do
      fixtures :users
      before{ @user = users(:example) }
      let(:credentials) do
        {
          email:@user.email,
          password:'invalid'
        }
      end
      it "does not log in" do
        post login_path, params:{ session:credentials }
        expect(is_logged_in?).to be(false)
      end
    end
    describe "remember me functionality" do
      fixtures :users
      let(:user){ users(:example) }
      def credentials(remember:) 
        { 
          session: {
            email:user.email,
            password:'password',
            remember_me: remember ? '1' : '0'
          }
        }
      end
      context "with remembering set to true" do
        it "sets the persisting cookie" do
          post login_path, params: credentials(remember:true) 
          expect(cookies[:remember_token]).to_not be_nil
        end
      end
      context "with remembering set to false" do
        it "does not set the persisting cookie" do
          post login_path, params: credentials(remember:false) 
          expect(cookies[:remember_token]).to be_nil
        end
      end
    end
  end
  describe "DELETE /logout" do
    fixtures :users
    before do
      @user = users(:example)
      post login_path, params:{ session:credentials }
      expect(is_logged_in?).to be(true)
      delete logout_path
    end
    let(:credentials) do
      {
        email:@user.email,
        password:"password"
      }
    end
    it "redirects to the home page" do
      expect(response).to redirect_to(root_path)
    end
    it "logs out" do
      expect(is_logged_in?).to be(false)
    end
    describe "following redirect" do
      before{ follow_redirect! }
      it "shows login links" do
        assert_select "a[href=?]", login_path
      end
      it "does not show logout links" do
        assert_select "a[href=?]", logout_path, count:0
      end
      it "does not show user profile links" do
        assert_select "a[href=?]", user_path(@user), count:0
      end
      context "when multiple logouts attempted from separate browsers" do
        it "does not raise an exception" do
          expect{ delete logout_path }.to_not raise_exception
        end
      end
    end
  end
end
