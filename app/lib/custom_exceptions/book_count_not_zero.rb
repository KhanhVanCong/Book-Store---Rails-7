# frozen_string_literal: true

module CustomExceptions
  class BookCountNotZero < Exception
    def initialize(message = nil)
      super(message || "can't remove this record because it related to book.")
    end
  end
end