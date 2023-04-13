require "rails_helper"

RSpec.describe "Order", type: :request do
  describe "checkout" do
    context "when the user does not login" do
      it "will fail" do
        checkout
        expect(response).to have_http_status(:found)
      end
    end

    context "when the use login" do
      it "will succeeded" do
        login(user.email, user.password)
        expect(response).to have_http_status(:redirect)
        add_item_to_cart(book.id)
        expect(response).to have_http_status(:ok)
        expect {
          checkout
          expect(response).to have_http_status(:ok)
        }.to change { user.cart.cart_items.count }.from(1).to(0)
        order = assigns(:order)
        expect(order.status).to eq(:pending)
      end
    end
  end
end