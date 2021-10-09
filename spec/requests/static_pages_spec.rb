require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title){ "RoR Sample App" }
  describe "GET root" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
    it "should have the right title" do
      get root_path
      expect(response.body).to have_title(base_title)
    end
  end

  describe "GET /help" do
    it "returns http success" do
      get help_path
      expect(response).to have_http_status(:success)
    end
    it "should have the right title" do
      get help_path
      expect(response.body).to have_title("Help | #{base_title}")
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_path
      expect(response).to have_http_status(:success)
    end
    it "should have the right title" do
      get about_path
      expect(response.body).to have_title("About | #{base_title}")
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get contact_path
      expect(response).to have_http_status(:success)
    end
    it "should have the right title" do
      get contact_path
      expect(response.body).to have_title("Contact | #{base_title}")
    end
  end

  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
    it "should have the right title" do
      get signup_path
      expect(response.body).to have_title("Sign up | #{base_title}")
    end
  end
end
