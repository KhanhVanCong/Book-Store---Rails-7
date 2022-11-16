class Book < ApplicationRecord
  has_many :book_authors, inverse_of: :book, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories
  has_many :book_tags, inverse_of: :book, dependent: :destroy
  has_many :tags, through: :book_tags
  has_many_attached :images do |attachable|
    attachable.variant :slider, resize_to_limit: [278, 401]
    attachable.variant :on_sale, resize_to_limit: [160, 232]
    attachable.variant :featured, resize_to_limit: [263, 380]
    attachable.variant :new_arrival, resize_to_limit: [213, 308]
    attachable.variant :thumbnail, resize_to_limit: [103, 150]
  end

  validates :description, :price, :author_ids, :tag_ids, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :images,
            attached: true,
            content_type: [:png, :jpg, :jpeg],
            size: { less_than: 5.megabytes, message: 'is too large' },
            limit: { min: 1, max: 3 },
            dimension: { width: 720, height: 1040 }
end
