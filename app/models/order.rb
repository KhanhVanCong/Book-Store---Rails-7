class Order < ApplicationRecord
  belongs_to :user
  has_many :order_books
  has_many :books, through: :order_books

  extend Enumerize
  enumerize :status, in: Constants::ORDER_STATUS, predicates: true, scope: true

  validates :shipping_address, presence: true
  validates :total_price, presence: true

  before_save :send_emails, if: :fresh_confirmed?

  def fresh_confirmed?
    self.status_changed? && self.confirmed?
  end

  private
    def send_emails
      OrderMailer.customer_order_confirmed(self).deliver_later
      OrderMailer.inform_new_order_for_admin(self).deliver_later
    end
end
