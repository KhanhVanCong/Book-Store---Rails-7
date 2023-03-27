class HomeController < ApplicationController
  def index
    @books = Book.all
    @book_ids_in_current_user_cart = current_user ? current_user.cart.books.ids : []
  end
end
