module Constants
  ADMIN_ROLES = [:super_admin, :admin]
  ADMIN_STATUS = [:active, :inactive]
  ORDER_STATUS = [:pending, :confirmed, :failed, :completed, :cancelled]
  FULL_TIME_FORMAT_FOR_DISPLAY = "%e %b %Y, %l:%M %p"
  BRAND_NAME = "BS"
  ORDER_CANCELLATION_BUFFER_HOURS = 2
  CURRENCY = "SGD"
  STRIPE_PAYMENT_METHODS = ["card", "grabpay", "paynow"]
  WEBHOOK_SECRET = ENV.fetch("STRIPE_WEBHOOK_SIGNING_KEY")
  STRIPE_PUBLISHABLE_KEY = ENV.fetch("STRIPE_PUBLISHABLE_KEY")
  MESSAGE_GENERAL_ERROR = "OOPS!!Something wrong here. We are checking "
end