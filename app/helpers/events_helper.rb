module EventsHelper
  require 'cgi'
  require 'icalendar'

  def google_calendar_link(event)
    params = {
      action: 'TEMPLATE',
      text: event.title,
      dates: "#{event.starts_at.utc.strftime('%Y%m%dT%H%M%SZ')}/#{event.ends_at.utc.strftime('%Y%m%dT%H%M%SZ')}",
      details: event.description,
      location: event.venue&.name,
      trp: false,
      sprop: '',
      sprop_name: ''
    }
    "https://www.google.com/calendar/render?#{params.to_query}"
  end

  def ics_event_content(event)
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = event.starts_at.utc
      e.dtend       = event.ends_at.utc
      e.summary     = event.title
      e.description = event.description
      e.location    = event.venue&.name
    end
    cal.publish
    cal.to_ical
  end
end
