ActiveAdmin.register Venue do
  permit_params :name, :address, :city, :capacity, :host_id, :location

  # ✅ Scopes
  scope :all, default: true
  scope("High Capacity") { |venues| venues.where("capacity > 500") }
  scope("Smaller Halls") { |venues| venues.where("capacity < 100") }

  # ✅ Filters
  filter :name
  filter :city
  filter :capacity
  filter :host, as: :select, collection: -> { Host.all.map { |host| [host.organisation, host.id] } }
  filter :created_at

  # ✅ Index page
  index do
    selectable_column
    id_column
    column :name
    column :address
    column :city
    column :capacity
    column("Host") { |venue| venue.host&.organisation }
    column :location
    column :created_at
    actions
  end

  # ✅ Show page
  show do
    attributes_table do
      row :name
      row :address
      row :city
      row :capacity
      row("Host") { |venue| venue.host&.organisation }
      row :location
      row :created_at
      row :updated_at
    end
  end

  # ✅ Form
  form do |f|
    f.inputs "Venue Details" do
      f.input :name
      f.input :address
      f.input :city
      f.input :capacity
      f.input :location
      f.input :host, as: :select, collection: Host.all.map { |h| [h.organisation, h.id] }
    end
    f.actions
  end
end
