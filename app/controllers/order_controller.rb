class OrderController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_cart

  def index
    @orders = current_user_orders.order(created_at: :desc)
  end

  def show
    @order = current_user_orders.find_by(id: params[:id])
  end

  def checkout
    @books = @cart.books
    @total_price = @books.sum(&:price)
  end

  def payment
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
          currency: Constants::CURRENCY,
          payment_method_types: Constants::STRIPE_PAYMENT_METHODS,
          metadata: {
            order_id: @order.id,
            user_id: current_user.id,
            book_ids: books.ids.join(",")
          }
        )
        @client_secret = payment_intent.client_secret
        @stripe_publishable_key = ENV["STRIPE_PUBLISHABLE_KEY"]
        @order.stripe_payment_intent = payment_intent.id
        @order.save!
      end
    rescue => e
      redirect_to order_checkout_path, alert: e.message
    end
  end

  def complete
    @order = current_user_orders.find_by(id: params[:id])
  end

  def reorder
    old_order = current_user_orders.find_by(id: order_params[:id])
    if old_order
      ActiveRecord::Base.transaction do
        @order = old_order.deep_clone include: [:order_books], only: [:total_price, :shipping_address]
        @order.user = current_user
        @order.status = :pending
        @order.save!

        book_ids = @order.order_books.collect(&:book_id).join(",")
        payment_intent = Stripe::PaymentIntent.create(
          amount: (@order.total_price * 100).to_i,
          currency: Constants::CURRENCY,
          payment_method_types: Constants::STRIPE_PAYMENT_METHODS,
          metadata: {
            order_id: @order.id,
            user_id: current_user.id,
            book_ids: book_ids
          }
        )
        @client_secret = payment_intent.client_secret
        @stripe_publishable_key = ENV["STRIPE_PUBLISHABLE_KEY"]
        @order.stripe_payment_intent = payment_intent.id
        @order.save!
      end

      if @order
        render "payment"
      else
        redirect_to orders_path, alert: "Something wrong"
      end
    else
      redirect_to orders_path, alert: "Can't not find your order"
    end
  end

  def cancel
    begin
      @order = current_user.orders.find_by(id: order_params[:id])
      if @order && @order.available_for_cancel?
        ActiveRecord::Base.transaction do
          refund = @order.refund_for_customer
          @order.status = :cancelled
          @order.stripe_refund_id = refund.id if refund
          @order.save!
        end
        redirect_to @order
      else
        redirect_to orders_path, alert: "This order is not available for cancel"
      end
    rescue => e
      redirect_to orders_path, alert: e.message
    end
  end

  private
    def current_user_cart
      @cart = current_user.cart
    end

    def order_params
      params.require(:order).permit(:shipping_address, :id)
    end

    def current_user_orders
      current_user.orders
    end
end
