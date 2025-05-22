ActiveAdmin.register Event do
  permit_params :title, :description, :starts_at, :ends_at, :host_id, :venue_id, :category_id

  # ✅ Scopes
  scope :all, default: true
  scope("Upcoming") { |events| events.where("starts_at >= ?", Time.current) }
  scope("Past")     { |events| events.where("ends_at < ?", Time.current) }

  # ✅ Filters
  filter :title
  filter :starts_at
  filter :ends_at
  filter :host, as: :select, collection: -> { User.where(role: "host") }
  filter :category
  filter :venue
  filter :created_at

  # ✅ Index table
  index do
    selectable_column
    id_column
    column :title
    column :host
    column :starts_at
    column :created_at
    actions
  end

  # ✅ Show view
  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :starts_at
      row :ends_at
      row :host
      row :venue
      row :category
      row :created_at
      row :updated_at
    end

    panel "Registrations" do
      table_for event.registrations do
        column :id
        column("Participant") { |r| r.participant.email }
        column :created_at
      end
    end

    active_admin_comments
  end
end
