FactoryBot.define do
  factory :order do
    user { nil }
    order_date_time { "2023-04-06 22:49:28" }
    full_price { "9.99" }
    shipping_address { "MyString" }
    status { "MyString" }
    stripe_charge_id { "MyString" }
    stripe_refund_id { "MyString" }
    stripe_application_id { "MyString" }
  end
end
