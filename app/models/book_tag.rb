class BookTag < ApplicationRecord
  belongs_to :book
  belongs_to :tag, counter_cache: :books_count

  validates :book, :tag, presence: true
end
