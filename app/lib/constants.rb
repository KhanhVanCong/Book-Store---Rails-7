module Constants
  ADMIN_ROLES = [:super_admin, :admin]
  ADMIN_STATUS = [:active, :inactive]
  ORDER_STATUS = [:pending, :confirmed, :failed, :completed, :cancelled]
  FULL_TIME_FORMAT_FOR_DISPLAY = "%e %b %Y, %l:%M %p"
  BRAND_NAME = "BS"
  ORDER_CANCELLATION_BUFFER_HOURS = 2
end