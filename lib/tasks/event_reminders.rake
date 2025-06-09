namespace :events do
  desc "Send reminder emails for events happening in the next 24 hours"
  task send_reminders: :environment do
    events = Event.where(starts_at: 24.hours.from_now..25.hours.from_now)
    events.each do |event|
      event.registrations.each do |registration|
        EventReminderJob.perform_later(registration.id)
      end
    end
    puts "Enqueued reminders for upcoming events."
  end
end
