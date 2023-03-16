require 'rails_helper'

RSpec.describe "cms/admins/show", type: :view do
  before(:each) do
    @cms_admin = assign(:cms_admin, Cms::Admin.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
