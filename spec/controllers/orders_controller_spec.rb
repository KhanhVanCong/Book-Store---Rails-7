require 'rails_helper'
RSpec.describe OrdersController, type: :controller do
  let(:signed_in_user) { create(:user) }
  let(:order) do
    signed_in_user.orders.create(
      total_price: 3,
      status: :pending,
      shipping_address: "shipping_address",
    )
  end
  let(:book) { create(:book) }
  let(:payment_intent) { double(Stripe::PaymentIntent, client_secret: "client_secret_fake", id: "pi_fake") }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(signed_in_user)
  end

  describe "GET #index" do
    it "assigns @orders and renders the :index view" do
      current_user_orders = signed_in_user.orders

      get :index

      expect(assigns(:orders).count).to eq current_user_orders.count
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    context "invalid order's id" do
      it "redirect to home page" do
        get :show, params: { id: "Fake_ID" }

        expect(response).to redirect_to(root_path)
      end
    end

    context "valid order's id" do
      it "assigns @order and renders the :show view" do
        get :show, params: { id: order.id }

        expect(assigns(:order)).to eq order
        expect(response).to render_template(:show)
      end
    end
  end

  describe "GET #checkout" do
    it "assigns @book, @total_price and renders the :checkout view" do
      CartItem.create(cart: signed_in_user.cart, book: book)

      get :checkout

      expect(assigns(:books)).to include book
      expect(assigns(:total_price)).to eq book.price
      expect(response).to render_template(:checkout)
    end
  end

  describe "POST #payment" do
    it "assigns @client_secret, @order and render checkout views" do
      CartItem.create(cart: signed_in_user.cart, book: book)
      expect(Stripe::PaymentIntent).to receive(:create).with(amount: (book.price * 100).to_i,
                                                             currency: Constants::CURRENCY,
                                                             payment_method_types: Constants::STRIPE_PAYMENT_METHODS,
                                                             metadata: { order_id: be_a(String) })
                                                       .and_return(payment_intent)

      post :payment, params: {
        order: {
          shipping_address: "Phan Thiet"
        }
      }

      expect(assigns(:client_secret)).to eq "client_secret_fake"
      expect(assigns(:order).stripe_payment_intent).to eq "pi_fake"
      expect(response).to render_template(:payment)
    end
  end

  describe "GET #complete" do
    context "invalid order's id" do
      it "redirect to home page" do
        get :complete, params: { id: "Fake_ID" }

        expect(response).to redirect_to(root_path)
      end
    end

    context "valid order's id" do
      it "assigns @order and renders the :complete view" do
        get :complete, params: { id: order.id }

        expect(assigns(:order)).to eq order
        expect(response).to render_template(:complete)
      end
    end
  end

  describe "POST #reorder" do
    context "invalid old order's id" do
      it "redirect to home page" do
        post :reorder, params: { order: { id: "Fake_ID" } }

        expect(response).to redirect_to(orders_path)
      end
    end

    context "valid old order's id" do
      it "assigns @order and redirect to payment page" do
        expect(Stripe::PaymentIntent).to receive(:create).with(amount: (order.total_price * 100).to_i,
                                                               currency: Constants::CURRENCY,
                                                               payment_method_types: Constants::STRIPE_PAYMENT_METHODS,
                                                               metadata: { order_id: be_a(String) })
                                                         .and_return(payment_intent)

        post :reorder, params: { order: { id: order.id } }

        new_order = assigns(:order)
        expect(assigns(:client_secret)).to eq "client_secret_fake"
        expect(new_order.stripe_payment_intent).to eq "pi_fake"
        expect(new_order.total_price).to eq order.total_price
        expect(response).to render_template(:payment)
      end

      it "redirects to the orders page with an error message if there is a Stripe error" do
        allow(Stripe::PaymentIntent).to receive(:create)
                                          .and_raise(Stripe::InvalidRequestError.new("Invalid Request",
                                                                                     "error_message",
                                                                                     json_body: { error: { code: "amount_too_small" } }))
        post :reorder, params: { order: { id: order.id } }

        expect(response).to redirect_to(orders_path)
        expect(flash[:alert]).to eq(ErrorDescriptions::Error_List[:MIN_AMOUNT_MUST_BE_0_5])
      end
    end
  end

  describe "PATCH #cancel" do
    context "invalid order's id" do
      it "redirect to oders page" do
        patch :cancel, params: { order: { id: "Fake_ID" } }

        expect(response).to redirect_to(orders_path)
      end
    end

    context "valid order's id" do
      context "available for cancel" do
        it "redirects to order page, set status to cancelled and refund money to customer if the order is paid" do
          order = signed_in_user.orders.create(
            total_price: 3,
            status: :confirmed,
            shipping_address: "shipping_address",
            stripe_charge_id: "ci_fake"
          )
          refund = double(Stripe::Refund, id: "rf_fake")
          expect(Stripe::Refund).to receive(:create).and_return(refund)

          patch :cancel, params: { order: { id: order.id } }

          assigns_order = assigns(:order)
          expect(assigns_order.status).to eq "cancelled"
          expect(assigns_order.stripe_refund_id).to eq "rf_fake"
          expect(assigns_order).to redirect_to(order)
        end

        it "redirects to order page, set status to cancelled and not refund money to customer if the order is not paid" do
          patch :cancel, params: { order: { id: order.id } }

          assigns_order = assigns(:order)
          expect(assigns_order.status).to eq "cancelled"
          expect(assigns_order.stripe_refund_id).to eq nil
          expect(assigns_order).to redirect_to(order)
        end
      end

      context "not available for cancel" do
        it "redirects to orders page with an error message" do
          allow_any_instance_of(Order).to receive(:available_for_cancel?).and_return(false)

          patch :cancel, params: { order: { id: order.id } }

          expect(response).to redirect_to(orders_path)
          expect(flash[:alert]).to eq(ErrorDescriptions::Error_List[:NOT_AVAILABLE_FOR_CANCEL])
        end
      end
    end
  end
end