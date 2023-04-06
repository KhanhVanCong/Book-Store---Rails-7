FactoryBot.define do
  factory :order_book do
    order { nil }
    book { nil }
    book_name { "MyString" }
    price_per_unit { "9.99" }
    quantity { 1 }
  end
end
