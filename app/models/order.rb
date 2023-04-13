class Order < ApplicationRecord
  belongs_to :user
  has_many :order_books
  has_many :books, through: :order_books

  extend Enumerize
  enumerize :status, in: Constants::ORDER_STATUS, predicates: true, scope: true

  validates :shipping_address, presence: true
  validates :total_price, presence: true

  before_create :generate_id
  after_update_commit :send_emails, if: :fresh_confirmed?

  def fresh_confirmed?
    self.previous_changes.has_key?(:status) && self.confirmed?
  end

  def display_created_at
    created_at.strftime(Constants::FULL_TIME_FORMAT_FOR_DISPLAY).squish
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
    def send_emails
      OrderMailer.customer_order_confirmed(self).deliver_later
      OrderMailer.inform_new_order_for_admin(self).deliver_later
    end
end
