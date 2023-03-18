class Cart < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :books, through: :orders
  belongs_to :user

  def exists_book_in_cart?(book_id)
    self.books.exists?(book_id)
  end
end
