import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="checkout"
export default class extends Controller {
  connect () {
    const stripe = Stripe('pk_test_51MuBZdDoqJ0Gd2j1FjQjpxGvQc5hhBbNS9CnqR2DqL5mqiANCgvRPRgD2uC9UJPlp7v0wc4V2893Hr9ZvgoHQlC900eXG9Py5o')
    const client_secret = document.getElementById('client_secret').innerHTML
    debugger
    const elements = stripe.elements({ clientSecret: client_secret })
    const payment_element = elements.create('payment')
    payment_element.mount('#payment-element')

    const form = document.getElementById('payment-form')
    form.addEventListener('submit', async (e) => {
      e.preventDefault()

      const { error } = await stripe.confirmPayment({
        elements,
        confirmParams: {
          return_url: window.location.origin + "/order/complete"
        }
      })

      if(error) {
        const messages = document.getElementById("error-messages")
        messages.innerText = error.message;
      }
    })
  }
}
