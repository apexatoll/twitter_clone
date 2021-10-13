require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe "#current_user" do
    fixtures :users
    let(:user){ users(:example) }
    before{ helper.remember(user) }
    context "when the session is set" do
      before{ helper.log_in(user) }
      it "returns the user" do
        expect(helper.current_user).to eq(user)
      end
    end
    context "when the session is not set" do
      context "when remember token matches remember digest" do
        it "returns the user" do
          expect(helper.current_user).to eq(user)
        end
        it "sets the session" do
          expect(helper).to be_logged_in
        end
      end
      context "when remember token does not match remember digest" do
        let(:new_digest){ User.digest(User.new_token) }
        before do
          user.update_attribute :remember_digest, new_digest
        end
        it "returns nil" do
          expect(helper.current_user).to be_nil
        end
        it "does not set the session" do
          expect(helper).to_not be_logged_in
        end
      end
    end
  end
end
