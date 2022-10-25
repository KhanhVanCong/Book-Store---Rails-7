require 'rails_helper'

RSpec.describe "cms/books/index", type: :view do
  before(:each) do
    assign(:cms_books, [
      Cms::Book.create!(),
      Cms::Book.create!()
    ])
  end

  it "renders a list of cms/books" do
    render
  end
end
