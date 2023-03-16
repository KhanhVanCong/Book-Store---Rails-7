class Category < ApplicationRecord
  include Books

  before_destroy :book_count_equal_zero?

  has_many :book_categories, dependent: :restrict_with_exception
  has_many :books, through: :book_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }
end
