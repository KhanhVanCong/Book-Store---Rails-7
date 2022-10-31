require 'rails_helper'

RSpec.describe "cms/authors/new", type: :view do
  before(:each) do
    assign(:cms_author, Cms::Author.new())
  end

  it "renders new cms_author form" do
    render

    assert_select "form[action=?][method=?]", cms_authors_path, "post" do
    end
  end
end
