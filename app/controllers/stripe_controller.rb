class StripeController < ApplicationController
  protect_from_forgery except: :webhook

  def webhook
    webhook_secret = ENV["STRIPE_WEBHOOK_SIGNING_KEY"]
    payload = request.body.read
    if webhook_secret.present?
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      event = nil

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, webhook_secret)

        case event.type
        when "payment_intent.succeeded"
          a = 1
        end

      rescue JSON::ParserError => e
        status 400
        return
      rescue Stripe::SignatureVerificationError => e
        puts "Webhook signature verification failed."
        status 400
        return
      end
    end
    status 200
    return
  end
end
