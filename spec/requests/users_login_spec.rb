require "rails_helper"

RSpec.describe "user login" do
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
    context "when incorrect login details are provided" do
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
  end
end
