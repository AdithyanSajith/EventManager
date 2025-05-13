json.extract! ticket, :id, :registration_id, :ticket_number, :issued_at, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
