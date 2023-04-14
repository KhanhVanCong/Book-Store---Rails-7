module OrdersHelper
  def payment
    post order_payment_path, params: {
      order: {
        shipping_address: "Phan Thiet"
      }
    }
  end

  def cancel(order_id)
    patch order_cancel_path, params: {
      order: {
        id: order_id
      }
    }
  end
end