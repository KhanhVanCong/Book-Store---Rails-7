class Order < ApplicationRecord
  belongs_to :user
  has_many :order_books
  has_many :books, through: :order_books

  extend Enumerize
  enumerize :status, in: Constants::ORDER_STATUS, predicates: true, scope: true

  validates :shipping_address, presence: true
  validates :total_price, presence: true

  before_create :generate_id
  after_update_commit :send_emails_for_confirmed_order, if: :fresh_confirmed?
  after_update_commit :send_emails_for_cancelled_order, if: :fresh_cancelled?

  def fresh_confirmed?
    self.previous_changes.has_key?(:status) && self.confirmed?
  end

  def fresh_cancelled?
    self.previous_changes.has_key?(:status) && self.cancelled?
  end

  def display_created_at
    created_at.strftime(Constants::FULL_TIME_FORMAT_FOR_DISPLAY).squish
  end

  def available_for_cancel?
    if status.in?(%w[completed failed cancelled]) ||
      (status == :confirmed && created_at < Time.zone.now - Constants::ORDER_CANCELLATION_BUFFER_HOURS.hours)
      return false
    end
    return true
  end

  def refund_for_customer
    refund = nil
    if status == :confirmed && stripe_charge_id.present?
      refund = Stripe::Refund.create(
        charge: self.stripe_charge_id,
        metadata: {
          order_id: self.id,
          user_id: self.user_id,
          book_ids: self.books.ids.join(","),
          cancellation_reason: "user cancel"
        }
      )
    end
    return refund
  end

  private

    def generate_id
      random_id = ""
      loop do
        random_id = "#{Constants::BRAND_NAME}_#{SecureRandom.random_number(10000000..99999999)}"
        break random_id unless self.class.exists?(id: random_id)
      end
      self.id = random_id
    end

    def send_emails_for_confirmed_order
      OrderMailer.customer_order_confirmed(self).deliver_later
      OrderMailer.inform_new_order_for_admin(self).deliver_later
    end

    def send_emails_for_cancelled_order
      OrderMailer.customer_cancelled_order(self).deliver_later
      OrderMailer.inform_cancelled_order_for_admin(self).deliver_later
    end
end
