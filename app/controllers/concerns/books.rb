module Books
  extend ActiveSupport::Concern

  included do
    def book_count_equal_zero?
      raise CustomExceptions::BookCountNotZero if self.books_count > 0
    end
  end
end