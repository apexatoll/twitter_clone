require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe "POST /microposts" do
    context "when not logged in" do
      def send_post(content:"Lorem ipsum")
        post microposts_path, params:{ micropost:{ content:content } }
      end
      it "redirects to login page" do
        send_post
        expect(response).to redirect_to(login_url)
      end
      it "does not post a new micropost" do
        expect{ send_post }.to_not change{ Micropost.count }
      end
    end
  end
  describe "DELETE /microposts/:id" do
    fixtures :microposts
    let(:micropost){ microposts(:hello_world) }
    def delete_post
      delete micropost_path(micropost)
    end
    it "redirects to login page" do
      delete_post
      expect(response).to redirect_to(login_url)
    end
    it "does not delete the post" do
      expect{ delete_post }.to_not change{ Micropost.count }
    end
  end
end
