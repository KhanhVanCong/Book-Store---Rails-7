class Book < ApplicationRecord
  has_many :book_authors, foreign_key: "book_id", dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags
  has_many_attached :images

  validates :description, :price, :images, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
