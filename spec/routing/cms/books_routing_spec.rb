require "rails_helper"

RSpec.describe Cms::BooksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/cms/books").to route_to("cms/books#index")
    end

    it "routes to #new" do
      expect(get: "/cms/books/new").to route_to("cms/books#new")
    end

    it "routes to #show" do
      expect(get: "/cms/books/1").to route_to("cms/books#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/cms/books/1/edit").to route_to("cms/books#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/cms/books").to route_to("cms/books#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/cms/books/1").to route_to("cms/books#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/cms/books/1").to route_to("cms/books#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/cms/books/1").to route_to("cms/books#destroy", id: "1")
    end
  end
end
