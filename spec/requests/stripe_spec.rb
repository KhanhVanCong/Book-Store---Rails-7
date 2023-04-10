require 'rails_helper'

RSpec.describe "Stripes", type: :request do
  describe "GET /webhook" do
    it "returns http success" do
      get "/stripe/webhook"
      expect(response).to have_http_status(:success)
    end
  end

end
