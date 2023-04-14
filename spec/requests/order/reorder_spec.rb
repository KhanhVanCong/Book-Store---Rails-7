require "rails_helper"

RSpec.describe "Order", type: :request do
  describe "reorder" do
    context "when the user does not login" do
      it "will fail" do
        reorder(1)
        expect(response).to have_http_status(:found)
      end
    end

    context "when the use login" do
      it "will succeeded" do
        login(user.email, user.password)
        expect(response).to have_http_status(:redirect)
        add_item_to_cart(book.id)
        expect(response).to have_http_status(:ok)
        payment
        expect(response).to have_http_status(:ok)
        order = assigns(:order)
        cancel(order.id)
        expect(response).to have_http_status(:found)
        reorder(order.id)
        expect(response).to have_http_status(:ok)
        new_order = assigns(:order)
        expect(new_order.status).to eq "pending"
        expect(new_order.order_books.count).to eq order.order_books.count
        expect(new_order.total_price).to eq order.total_price
        expect(new_order.shipping_address).to eq order.shipping_address
        expect(new_order.id).not_to eq order.id
      end
    end
  end
end