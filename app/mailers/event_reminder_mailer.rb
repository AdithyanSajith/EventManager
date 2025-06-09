class EventReminderMailer < ApplicationMailer
  def reminder_email(registration)
    @registration = registration
    @event = registration.event
    @participant = registration.participant
    mail(to: @participant.email, subject: "Reminder: Upcoming Event - #{@event.title}")
  end
end
