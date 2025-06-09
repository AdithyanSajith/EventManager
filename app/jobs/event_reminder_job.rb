class EventReminderJob < ApplicationJob
  queue_as :default

  def perform(registration_id)
    registration = Registration.find_by(id: registration_id)
    return unless registration && registration.participant&.email.present?
    EventReminderMailer.reminder_email(registration).deliver_now
  end
end
