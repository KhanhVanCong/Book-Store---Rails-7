require 'rails_helper'

RSpec.describe "cms/books/show", type: :view do
  before(:each) do
    @cms_book = assign(:cms_book, Cms::Book.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
