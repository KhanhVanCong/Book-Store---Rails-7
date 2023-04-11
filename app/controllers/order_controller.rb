class OrderController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :current_user_cart

  def show
    @books = @cart.books
    @total_price = @books.sum(&:price)
  end

  def checkout
    begin
      ActiveRecord::Base.transaction do
        books = @cart.books
        total_price = books.sum(&:price)
        CartItem.where(cart_id: @cart.id).delete_all

        @order = current_user.orders.new(
          total_price: total_price,
          status: :pending,
          shipping_address: order_params[:shipping_address]
        )

        books.each do |book|
          @order.order_books.new(
            book: book,
            book_title: book.title,
            price_per_unit: book.price,
            quantity: 1
          )
        end
        @order.save!

        payment_intent = Stripe::PaymentIntent.create(
          amount: (total_price * 100).to_i,
          currency: "SGD",
          payment_method_types: ["card", "grabpay", "paynow"],
          metadata: {
            order_id: @order.id,
            user_id: current_user.id,
            book_ids: books.ids.join(",")
          }
        )
        @client_secret = payment_intent.client_secret
        @stripe_publishable_key = ENV["STRIPE_PUBLISHABLE_KEY"]
        @order.stripe_payment_intent = @client_secret
        @order.save!
      end
    rescue => e
      redirect_to order_show_path, alert: e.message
    end
  end

  def complete
    @payment_intent = Stripe::PaymentIntent.retrieve(params[:payment_intent])
  end

  private

    def current_user_cart
      @cart = current_user.cart
    end

    def order_params
      params.require(:order).permit(:shipping_address)
    end
end
