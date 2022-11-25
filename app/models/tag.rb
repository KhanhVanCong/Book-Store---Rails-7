class Tag < ApplicationRecord
  include Books

  before_destroy :book_count_equal_zero?

  has_many :book_tags, dependent: :restrict_with_exception
  has_many :books, through: :book_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
end
