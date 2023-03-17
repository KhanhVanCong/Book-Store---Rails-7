class Cart < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :books, through: :orders
  belongs_to :user
end
