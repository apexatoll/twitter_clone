require 'rails_helper'

RSpec.describe Micropost, type: :model do
  fixtures :users
  let(:user){ users(:example) }
  let(:content){ "Lorem ipsum" }
  subject do
    user.microposts.build(content:content)
  end
  describe "#valid?" do
    context "with valid content and a valid user" do
      it "is valid" do
        expect(subject).to be_valid
      end
    end
    context "without valid content" do
      let(:content){ nil }
      it "is not valid" do
        expect(subject).to_not be_valid
      end
    end
    context "with blank content" do
      let(:content){ " " }
      it "is not valid" do
        expect(subject).to_not be_valid
      end
    end
    describe "content is maximum of 140 characters" do
      let(:content){ "x" * 141 }
      it "is not valid" do
        expect(subject).to_not be_valid
      end
    end
  end
  describe "order" do
    fixtures :microposts
    it "is from most recent to oldest" do
      expect(microposts(:most_recent)).to eq(Micropost.first)
    end
  end
end
