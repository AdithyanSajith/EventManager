import { Application } from "@hotwired/stimulus"
import PaymentController from "./payment_controller"

const application = Application.start()
application.register("payment", PaymentController)
