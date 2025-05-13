json.extract! managed_event, :id, :title, :description, :starts_at, :ends_at, :host_id, :category_id, :venue_id, :created_at, :updated_at
json.url managed_event_url(managed_event, format: :json)
