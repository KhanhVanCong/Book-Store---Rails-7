import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="checkout"
export default class extends Controller {
  connect () {
    const client_secret = document.getElementById("client_secret").innerHTML
    const stripe_publishable_key = document.getElementById("stripe_publishable_key").innerHTML
    const order_id = document.getElementById("order_id").innerHTML
    const stripe = Stripe(stripe_publishable_key)
    debugger
    const elements = stripe.elements({ clientSecret: client_secret })
    const payment_element = elements.create("payment")
    payment_element.mount("#payment-element")

    const form = document.getElementById("payment-form")
    form.addEventListener("submit", async (e) => {
      e.preventDefault()

      const { error } = await stripe.confirmPayment({
        elements,
        confirmParams: {
          return_url: `${window.location.origin}/order/complete?id=${order_id}`
        }
      })

      if (error) {
        const messages = document.getElementById("error-messages")
        messages.innerText = error.message
      }
    })
  }
}
