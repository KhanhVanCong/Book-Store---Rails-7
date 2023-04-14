require "rails_helper"

RSpec.describe "Order", type: :request do
  describe "cancel" do
    context "when the user does not login" do
      it "will fail" do
        cancel(book.id)
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
        expect {
          cancel(order.id)
          expect(response).to have_http_status(:found)
          order.reload
        }.to change { order.status }.from("pending").to("cancelled")
      end
    end
  end
end