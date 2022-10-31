require 'rails_helper'

RSpec.describe "cms/authors/edit", type: :view do
  before(:each) do
    @cms_author = assign(:cms_author, Cms::Author.create!())
  end

  it "renders the edit cms_author form" do
    render

    assert_select "form[action=?][method=?]", cms_author_path(@cms_author), "post" do
    end
  end
end
