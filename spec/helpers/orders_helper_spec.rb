module OrdersHelper
  def payment
    VCR.use_cassette("stripe_payment") do
      post orders_payment_path, params: {
        order: {
          shipping_address: "Phan Thiet"
        }
      }
    end
  end

  def cancel(order_id)
    VCR.use_cassette("stripe_cancel") do
      patch order_cancel_path, params: {
        order: {
          id: order_id
        }
      }
    end
  end

  def reorder(order_id)
    VCR.use_cassette("stripe_reorder") do
      post orders_reorder_path, params: {
        order: {
          id: order_id
        }
      }
    end
  end
end