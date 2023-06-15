module StripeHelper
  def generate_payload(type)
    file_example_payload = File.open("spec/files/payload/#{type}.json")
    JSON.load(file_example_payload)
  end

  def generate_stripe_event_signature(payload)
    secret = Constants::WEBHOOK_SECRET
    time = Time.now
    signature = Stripe::Webhook::Signature.compute_signature(time, payload, secret)
    Stripe::Webhook::Signature.generate_header(
      time,
      signature,
      scheme: Stripe::Webhook::Signature::EXPECTED_SCHEME
    )
  end

  def post_stripe_hook(payload, headers = {})
    headers = { "Stripe-Signature": generate_stripe_event_signature(payload.to_json) }.merge(headers)
    post "/stripe/webhook", params: payload, headers: headers, as: :json
  end
end