// app/javascript/controllers/event_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]

  connect() {
    const eventId = this.element.dataset.eventId

    fetch(`/api/v1/events/${eventId}/registration_status.json`)
      .then(response => response.json())
      .then(data => {
        if (data.paid) {
          this.statusTarget.innerText = "✅ Ticket Issued"
        } else if (data.registered) {
          this.statusTarget.innerText = "🕒 Registered, payment pending"
        } else {
          this.statusTarget.innerText = "❌ Not Registered"
        }
      })
      .catch(err => {
        console.error("Status fetch failed", err)
        this.statusTarget.innerText = "Error loading status"
      })
  }
}
