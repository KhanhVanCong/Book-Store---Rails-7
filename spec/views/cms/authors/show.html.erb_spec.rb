require 'rails_helper'

RSpec.describe "cms/authors/show", type: :view do
  before(:each) do
    @cms_author = assign(:cms_author, Cms::Author.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
