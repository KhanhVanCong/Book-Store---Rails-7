class OrdersMailer < ApplicationMailer
  def customer_order_confirmed(order)
    user = order.user
    mail(to: user.email,
         subject: "Your order - #{order.id} is confirmed",
         body: "Hi #{user.first_name}. Thank you for using Book Store. Your order - #{order.id} is processing and will be delivered soon.",
         content_type: "text/html")
  end

  def inform_new_order_for_admin(order)
    mail(to: "admin@bookstore.com",
         subject: "We have a new order - #{order.id}",
         body: "Hi team, we have a new order - #{order.id}. Plz take a look and process this order. Thank you!",
         content_type: "text/html")
  end

  def customer_cancelled_order(order)
    user = order.user
    mail(to: user.email,
         subject: "Your order - #{order.id} cancelled",
         body: "Hi #{user.first_name}. Thank you for using Book Store. Your order - #{order.id} cancelled successfully.
                If you have a payment, we will refund the full of the money for you soon.",
         content_type: "text/html")
  end

  def inform_cancelled_order_for_admin(order)
    mail(to: "admin@bookstore.com",
         subject: "The order - #{order.id} is cancelled",
         body: "Hi team, the customer - #{order.user.email} is cancelled the order - #{order.id}. FYI!",
         content_type: "text/html")
  end
end