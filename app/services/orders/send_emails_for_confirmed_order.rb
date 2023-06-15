module Orders
  module SendEmailsForConfirmedOrder
    def self.call(order)
      OrdersMailer.customer_order_confirmed(order).deliver_later
      OrdersMailer.inform_new_order_for_admin(order).deliver_later
    end
  end
end