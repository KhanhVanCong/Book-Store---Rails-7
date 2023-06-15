Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY")
Stripe.api_base = "http://localhost:12111" if Rails.env == "test"
