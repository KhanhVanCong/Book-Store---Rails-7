class BookAuthor < ApplicationRecord
  belongs_to :author, counter_cache: :books_count
  belongs_to :book

  validates :author, :book, presence: true
end
