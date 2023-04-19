class StripeController < ApplicationController
  protect_from_forgery except: :webhook

  def webhook
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    payload = request.body.read

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, Constants::WEBHOOK_SECRET)

      event_data = event.data.object
      metadata = event_data.metadata
      case event.type
      when "payment_intent.succeeded"
        order = Order.find_by(id: metadata.order_id)
        if order && order.status = "pending"
          order.status = :confirmed
          order.stripe_charge_id = event_data.latest_charge
          order.save
          Orders::SendEmailsForConfirmedOrder.call(order) if order
        end
      when "payment_intent.payment_failed"
        order = Order.find_by(id: metadata.order_id)
        if order
          order.status = :failed
          order.save
        end
      end

    rescue JSON::ParserError => e
      render status: 400, body: e.message and return
    rescue Stripe::SignatureVerificationError => e
      puts "Webhook signature verification failed."
      render status: 400, body: e.message and return
    end

    render status: 200, body: "" and return
  end
end
