require "rails_helper"

RSpec.describe Cms::AdminsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/cms/admins").to route_to("cms/admins#index")
    end

    it "routes to #new" do
      expect(get: "/cms/admins/new").to route_to("cms/admins#new")
    end

    it "routes to #show" do
      expect(get: "/cms/admins/1").to route_to("cms/admins#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/cms/admins/1/edit").to route_to("cms/admins#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/cms/admins").to route_to("cms/admins#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/cms/admins/1").to route_to("cms/admins#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/cms/admins/1").to route_to("cms/admins#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/cms/admins/1").to route_to("cms/admins#destroy", id: "1")
    end
  end
end
