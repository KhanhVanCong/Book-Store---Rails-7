require "rails_helper"

RSpec.describe "Order", type: :request do
  describe "cancel" do
    context "when the user does not login" do
      it "will fail" do
        cancel(1)
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
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
         .and have_enqueued_mail(OrdersMailer, :customer_cancelled_order).with(order).exactly(1)
         .and have_enqueued_mail(OrdersMailer, :inform_cancelled_order_for_admin).with(order).exactly(1)
      end
    end
  end
end