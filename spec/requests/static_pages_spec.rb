require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title){ "RoR Sample App" }
  describe "GET /home" do
    it "returns http success" do
      get "/static_pages/home"
      expect(response).to have_http_status(:success)
    end
    it "should have the right title" do
      get "/static_pages/home"
      expect(response.body).to have_title("Home | #{base_title}")
    end
  end

  describe "GET /help" do
    it "returns http success" do
      get "/static_pages/help"
      expect(response).to have_http_status(:success)
    end
    it "should have the right title" do
      get "/static_pages/help"
      expect(response.body).to have_title("Help | #{base_title}")
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get "/static_pages/about"
      expect(response).to have_http_status(:success)
    end
    it "should have the right title" do
      get "/static_pages/about"
      expect(response.body).to have_title("About | #{base_title}")
    end
  end
end