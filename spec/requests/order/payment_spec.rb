require "rails_helper"
require "json"

RSpec.describe "Order", type: :request do
  describe "payment" do
    context "when the user does not login" do
      it "will fail" do
        payment
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      end
    end

    context "when the user login" do
      it "will succeed after successful payment" do
        login(user.email, user.password)
        expect(response).to have_http_status(:redirect)
        add_item_to_cart(book.id)
        expect(response).to have_http_status(:ok)
        expect {
          payment
          expect(response).to have_http_status(:ok)
        }.to change { user.cart.cart_items.count }.from(1).to(0)
        order = assigns(:order)
        expect(order.status).to eq(:pending)
        payload = generate_payload("payment_intent.succeeded")
        payload["data"]["object"]["metadata"] = { order_id: order.id }
        expect {
          post_stripe_hook(payload)
          order.reload
        }.to change { order.status }.from("pending").to("confirmed")
         .and have_enqueued_mail(OrdersMailer, :customer_order_confirmed).with(order).exactly(1)
         .and have_enqueued_mail(OrdersMailer, :inform_new_order_for_admin).with(order).exactly(1)
      end

      it "will fail after unsuccessful payment" do
        login(user.email, user.password)
        add_item_to_cart(book.id)
        payment
        order = assigns(:order)
        payload = generate_payload("payment_intent.payment_failed")
        payload["data"]["object"]["metadata"] = { order_id: order.id }
        expect {
          post_stripe_hook(payload)
          order.reload
        }.to change { order.status }.from("pending").to("failed")
      end
    end
  end
end