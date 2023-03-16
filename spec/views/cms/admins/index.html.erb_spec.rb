require 'rails_helper'

RSpec.describe "cms/admins/index", type: :view do
  before(:each) do
    assign(:cms_admins, [
      Cms::Admin.create!(),
      Cms::Admin.create!()
    ])
  end

  it "renders a list of cms/admins" do
    render
  end
end
