class Author < ApplicationRecord
  include Books

  before_destroy :book_count_equal_zero?

  has_many :book_authors, inverse_of: :author, dependent: :restrict_with_exception
  has_many :books, through: :book_authors
  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_limit: [168, 197]
    attachable.variant :medium, resize_to_limit: [270, 335]
    attachable.variant :big, resize_to_limit: [370, 430]
  end

  validates :description, presence: true
  validates :first_name, :last_name, presence: true, length: { maximum: 100 }
  validates :avatar,
            attached: true,
            content_type: [:png, :jpg, :jpeg],
            size: { less_than: 3.megabytes, message: 'is too large' },
            dimension: { width: 370, height: 460 }

  def display_name
    "#{first_name} #{last_name}"
  end
end