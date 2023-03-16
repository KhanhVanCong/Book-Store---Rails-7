require 'rails_helper'

RSpec.describe "cms/admins/new", type: :view do
  before(:each) do
    assign(:cms_admin, Cms::Admin.new())
  end

  it "renders new cms_admin form" do
    render

    assert_select "form[action=?][method=?]", cms_admins_path, "post" do
    end
  end
end
