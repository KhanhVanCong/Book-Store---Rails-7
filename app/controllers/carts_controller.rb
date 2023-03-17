class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_cart

  def add_item
    book = Book.find_by!(cart_params[:book_id])
    Order.create(cart: @cart, book: book)
  end

  private
    def cart_params
      params.require(:cart).permit(:book_id)
    end

    def current_user_cart
      @cart = current_user.cart
    end
end
