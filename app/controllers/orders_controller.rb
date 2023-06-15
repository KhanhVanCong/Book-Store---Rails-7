class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_cart

  def index
    @orders = current_user_orders.order(created_at: :desc)
  end

  def show
    @order = current_user_orders.find_by(id: params[:id])
    redirect_to root_path, alert: ErrorDescriptions::Error_List[:ORDER_NOT_FOUND] unless @order
  end

  def checkout
    @books = @cart.books
    @total_price = @books.sum(&:price)
  end

  def payment
    begin
      books = @cart.books
      total_price = books.sum(&:price)

      ActiveRecord::Base.transaction do
        CartItem.where(cart_id: @cart.id).delete_all

        @order = current_user.orders.new(
          total_price: total_price,
          status: :pending,
          shipping_address: order_params[:shipping_address]
        )

        books.each do |book|
          @order.order_books.new(
            book: book,
            price_per_unit: book.price,
            quantity: 1
          )
        end

        @order.save
      end

      if @order.valid?
        payment_intent = Stripe::PaymentIntent.create(
          amount: (total_price * 100).to_i,
          currency: Constants::CURRENCY,
          payment_method_types: Constants::STRIPE_PAYMENT_METHODS,
          metadata: { order_id: @order.id }
        )
        @client_secret = payment_intent.client_secret
        @order.stripe_payment_intent = payment_intent.id
        @order.save
      else
        redirect_to orders_checkout_path, alert: @order.errors.full_messages.join(", ")
      end
    rescue Stripe::InvalidRequestError => e
      err_message = handle_stripe_error_messages(e)
      redirect_to orders_checkout_path, alert: err_message
    end
  end

  def complete
    @order = current_user_orders.find_by(id: params[:id])
    redirect_to root_path, alert: ErrorDescriptions::Error_List[:ORDER_NOT_FOUND] unless @order
  end

  def reorder
    old_order = current_user_orders.find_by(id: order_params[:id])
    if old_order
      begin
        @order = old_order.deep_clone include: [:order_books], only: [:total_price, :shipping_address]
        @order.user = current_user
        @order.status = :pending
        @order.save

        if @order.valid?
          payment_intent = Stripe::PaymentIntent.create(
            amount: (@order.total_price * 100).to_i,
            currency: Constants::CURRENCY,
            payment_method_types: Constants::STRIPE_PAYMENT_METHODS,
            metadata: { order_id: @order.id }
          )
          @client_secret = payment_intent.client_secret
          @order.stripe_payment_intent = payment_intent.id
          @order.save

          if @order.valid?
            render "payment"
          else
            redirect_to orders_checkout_path, alert: @order.errors.full_messages.join(", ")
          end
        else
          redirect_to orders_checkout_path, alert: @order.errors.full_messages.join(", ")
        end
      rescue Stripe::InvalidRequestError => e
        err_message = handle_stripe_error_messages(e)
        redirect_to orders_path, alert: err_message
      end
    else
      redirect_to orders_path, alert: ErrorDescriptions::Error_List[:ORDER_NOT_FOUND]
    end
  end

  def cancel
    begin
      @order = current_user.orders.find_by(id: order_params[:id])
      if @order && @order.available_for_cancel?
        refund = @order.refund_for_customer
        @order.status = :cancelled
        @order.stripe_refund_id = refund.id if refund
        @order.save
        Orders::SendEmailsForCancelledOrder.call(@order)
        redirect_to @order
      else
        redirect_to orders_path, alert: ErrorDescriptions::Error_List[:NOT_AVAILABLE_FOR_CANCEL]
      end
    rescue => e
      Honeybadger.notify(e)
      redirect_to orders_path, alert: ErrorDescriptions::Error_List[:CANCEL_ORDER_FAILURE]
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

    def handle_stripe_error_messages(err)
      err_code = err.json_body[:error][:code]
      case err_code
      when "amount_too_small"
        err_message = ErrorDescriptions::Error_List[:MIN_AMOUNT_MUST_BE_0_5]
      else
        err_message = err.message
      end
      err_message
    end
end
