ActiveAdmin.register Event do
  # Filters in the sidebar
  filter :title
  filter :starts_at
  filter :host, as: :select, collection: -> { User.where(role: 'host') }

  # Index page customization
  index do
    selectable_column
    id_column
    column :title
    column :host
    column :starts_at
    column :created_at
    actions
  end

  # Show page customization
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
