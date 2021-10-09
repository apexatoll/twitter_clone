require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do

  subject { get root_path }

  it "renders the correct template" do
    expect(get root_path).to render_template("static_pages/home")
  end

  describe "page links" do
    
    before(:each){ get root_path }

    def test_link(link, attributes={})
      assert_select "a[href=?]", link, attributes
    end

    it "has two links to the homepage" do
      test_link root_path, count:2
    end

    it "links to the help page" do
      test_link help_path
    end

    it "links to the about page" do
      test_link about_path
    end

    it "links to the contact page" do
      test_link contact_path
    end
  end
end
