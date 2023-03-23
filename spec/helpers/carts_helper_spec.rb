module CartsHelper
  def add_item_to_cart(book_id)
    post cart_path, params: {
      cart: {
        book_id: book_id
      }
    }
  end

  def empty_cart
    delete empty_cart_path
  end

  def remove_item_to_cart(book_id)
    delete cart_path, params: {
      cart: {
        book_id: book_id
      }
    }
  end

  def get_cart
    get cart_path
  end
end