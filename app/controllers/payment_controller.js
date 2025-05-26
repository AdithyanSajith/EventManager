import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "status"]

  connect() {
    this.fetchStatus()
  }

  fetchStatus() {
    const eventId = this.data.get("eventId")
    fetch(`/api/v1/events/${eventId}/registration_status.json`, {
      headers: { "Accept": "application/json" }
    })
      .then(resp => resp.json())
      .then(data => {
        if (data.paid) {
          this.statusTarget.textContent = "✅ Ticket Issued"
          this.buttonTarget.style.display = "none"
        } else if (data.registered) {
          this.statusTarget.textContent = "🕒 Registered, payment pending"
          this.buttonTarget.style.display = "inline-block"
          this.buttonTarget.textContent = "Pay Now"
        } else {
          this.statusTarget.textContent = "❌ Not Registered"
          this.buttonTarget.style.display = "inline-block"
          this.buttonTarget.textContent = "Register & Pay"
        }
      })
      .catch(() => {
        this.statusTarget.textContent = "Error loading status"
      })
  }

  pay() {
    const eventId = this.data.get("eventId")
    const paymentData = { payment: { amount: 100, card_number: "4111111111111111" } } // replace with actual inputs

    fetch(`/api/v1/events/${eventId}/payments`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
        "Accept": "application/json"
      },
      body: JSON.stringify(paymentData),
    })
      .then(resp => resp.json())
      .then(data => {
        if (data.message) {
          this.statusTarget.textContent = data.message
          this.fetchStatus()
        } else if (data.errors) {
          alert("Payment failed: " + data.errors.join(", "))
        }
      })
      .catch(() => {
        alert("Payment request failed.")
      })
  }
}
