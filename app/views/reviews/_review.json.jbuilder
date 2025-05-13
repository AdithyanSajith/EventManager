json.extract! review, :id, :rating, :comment, :participant_id, :event_id, :created_at, :updated_at
json.url review_url(review, format: :json)
