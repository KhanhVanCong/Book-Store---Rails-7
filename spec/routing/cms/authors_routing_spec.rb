require "rails_helper"

RSpec.describe Cms::AuthorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/cms/authors").to route_to("cms/authors#index")
    end

    it "routes to #new" do
      expect(get: "/cms/authors/new").to route_to("cms/authors#new")
    end

    it "routes to #show" do
      expect(get: "/cms/authors/1").to route_to("cms/authors#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/cms/authors/1/edit").to route_to("cms/authors#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/cms/authors").to route_to("cms/authors#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/cms/authors/1").to route_to("cms/authors#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/cms/authors/1").to route_to("cms/authors#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/cms/authors/1").to route_to("cms/authors#destroy", id: "1")
    end
  end
end
