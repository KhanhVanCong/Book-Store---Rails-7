class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_cart

  def add_item
    @book = Book.find_by!(id: cart_params[:book_id])
    Order.create(cart: @cart, book: @book)
    flash.now[:notice] = "The book - #{@book.title.capitalize} is added to your cart."
    respond_to do |format|
      format.turbo_stream
      format.html { render body: "" }
    end
  end

  def remove_item
    @book = Book.find_by!(id: cart_params[:book_id])
    order = Order.find_by!(cart_id: @cart.id, book_id: @book.id)
    order.destroy!
    flash.now[:notice] = "The book - #{@book.title.capitalize} is removed from your cart."
    respond_to do |format|
      format.turbo_stream { render "carts/add_item" }
      format.html { render body: "" }
    end
  end

  private
    def cart_params
      params.require(:cart).permit(:book_id)
    end

    def current_user_cart
      @cart = current_user.cart
    end
end
