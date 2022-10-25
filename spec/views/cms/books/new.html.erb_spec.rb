require 'rails_helper'

RSpec.describe "cms/books/new", type: :view do
  before(:each) do
    assign(:cms_book, Cms::Book.new())
  end

  it "renders new cms_book form" do
    render

    assert_select "form[action=?][method=?]", cms_books_path, "post" do
    end
  end
end
