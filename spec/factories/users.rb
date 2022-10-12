FactoryBot.define do
  factory :user do
    first_name { "Foo" }
    last_name { "Fii" }
    sequence(:email) { |i| "foo_#{i}@example.com" }
    password { "Qwer@123456" }
    confirmed_at { DateTime.now }
  end
end