class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :books, through: :cart_items
  belongs_to :user

  def exists_book_in_cart?(book_id)
    self.books.exists?(book_id)
  end
end
