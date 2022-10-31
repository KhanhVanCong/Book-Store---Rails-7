require 'rails_helper'

RSpec.describe "cms/authors/index", type: :view do
  before(:each) do
    assign(:cms_authors, [
      Cms::Author.create!(),
      Cms::Author.create!()
    ])
  end

  it "renders a list of cms/authors" do
    render
  end
end
