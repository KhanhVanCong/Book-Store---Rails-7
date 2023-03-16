require 'rails_helper'

RSpec.describe "cms/admins/edit", type: :view do
  before(:each) do
    @cms_admin = assign(:cms_admin, Cms::Admin.create!())
  end

  it "renders the edit cms_admin form" do
    render

    assert_select "form[action=?][method=?]", cms_admin_path(@cms_admin), "post" do
    end
  end
end
