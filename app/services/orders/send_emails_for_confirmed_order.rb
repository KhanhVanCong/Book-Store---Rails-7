module Orders
  module SendEmailsForConfirmedOrder
    def self.call(order)
      OrderMailer.customer_order_confirmed(order).deliver_later
      OrderMailer.inform_new_order_for_admin(order).deliver_later
    end
  end
end