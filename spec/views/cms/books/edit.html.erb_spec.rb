require 'rails_helper'

RSpec.describe "cms/books/edit", type: :view do
  before(:each) do
    @cms_book = assign(:cms_book, Cms::Book.create!())
  end

  it "renders the edit cms_book form" do
    render

    assert_select "form[action=?][method=?]", cms_book_path(@cms_book), "post" do
    end
  end
end
