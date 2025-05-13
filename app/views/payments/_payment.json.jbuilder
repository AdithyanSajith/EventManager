json.extract! payment, :id, :amount, :status, :paid_at, :registration_id, :created_at, :updated_at
json.url payment_url(payment, format: :json)
