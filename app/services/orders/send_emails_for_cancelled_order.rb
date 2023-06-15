module Orders
  module SendEmailsForCancelledOrder
    def self.call(order)
      OrdersMailer.customer_cancelled_order(order).deliver_later
      OrdersMailer.inform_cancelled_order_for_admin(order).deliver_later
    end
  end
end