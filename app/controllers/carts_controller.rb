class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_cart

  def show
    @books = @cart.books
    @total_price = @books.sum(&:price)
  end

  def add_item
    @book = Book.find_by!(id: cart_params[:book_id])
    CartItem.create(cart: @cart, book: @book)
    flash.now[:notice] = "The book - #{@book.title.capitalize} is added to your cart."
    respond_to do |format|
      format.turbo_stream
      format.html { render body: "" }
    end
  end

  def remove_item
    @book = Book.find_by!(id: cart_params[:book_id])
    CartItem.where(cart_id: @cart.id, book_id: @book.id).delete_all
    flash.now[:notice] = "The book - #{@book.title.capitalize} is removed from your cart."
    respond_to do |format|
      format.turbo_stream { render "carts/add_item" }
      format.html { render body: "" }
    end
  end

  def empty_cart
    CartItem.where(cart_id: @cart.id).delete_all
    flash[:notice] = "Empty your cart successfully."
    redirect_to root_path
  end

  private
    def cart_params
      params.require(:cart).permit(:book_id)
    end

    def current_user_cart
      @cart = current_user.cart
    end
end
