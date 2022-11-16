class Tag < ApplicationRecord
  before_destroy :is_zero_book?

  has_many :book_tags
  has_many :books, through: :book_tags

  validates :name, presence: true, length: { maximum: 50 }

  private
    def is_zero_book?
      self.books_count > 0 ? false : true
    end
end
