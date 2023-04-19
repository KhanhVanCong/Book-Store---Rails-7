class Order < ApplicationRecord
  belongs_to :user
  has_many :order_books
  has_many :books, through: :order_books

  extend Enumerize
  enumerize :status, in: Constants::ORDER_STATUS, predicates: true, scope: true

  validates :shipping_address, presence: true
  validates :total_price, presence: true

  before_create :generate_id

  def display_created_at
    created_at.strftime(Constants::FULL_TIME_FORMAT_FOR_DISPLAY).squish
  end

  def available_for_cancel?
    if status.in?(%w[completed failed cancelled]) ||
      (status == :confirmed && created_at < Time.current - Constants::ORDER_CANCELLATION_BUFFER_HOURS.hours)
      return false
    end
    return true
  end

  def refund_for_customer
    refund = nil
    if status == :confirmed && stripe_charge_id.present?
      refund = Stripe::Refund.create(
        charge: self.stripe_charge_id,
        metadata: { order_id: self.id, cancellation_reason: "user cancel" }
      )
    end
    return refund
  end

  private
    def generate_id
      self.id = ULID.generate
    end
end
