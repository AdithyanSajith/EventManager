if defined?(User)
  ActiveAdmin.register User do
    # ✅ Permit strong parameters
    permit_params :email, :name, :role, :interest, :city, :birthdate,
                  :organisation, :website, :number, :bio,
                  :password, :password_confirmation

    # ✅ Scopes for filtering by role
    scope :all, default: true
    scope("Hosts") { |users| users.where(role: "host") }
    scope("Participants") { |users| users.where(role: "participant") }

    # ✅ Filters in the sidebar
    filter :name
    filter :email
    filter :role, as: :select, collection: ["host", "participant"]
    filter :city
    filter :interest
    filter :birthdate
    filter :created_at

    # ✅ Index page
    index do
      selectable_column
      id_column
      column :name
      column :email
      column :role
      column :created_at
      actions
    end

    # ✅ Show page
    show do
      attributes_table do
        row :id
        row :name
        row :email
        row :role
        row :interest
        row :city
        row :birthdate
        row :organisation
        row :website
        row :number
        row :bio
        row :created_at
        row :updated_at
      end
    end

    # ✅ Form for new/edit
    form do |f|
      f.inputs "User Details" do
        f.input :email
        f.input :name
        f.input :role, as: :select, collection: %w[host participant admin]
        f.input :interest
        f.input :city
        f.input :birthdate, as: :datepicker
        f.input :organisation
        f.input :website
        f.input :number
        f.input :bio
        f.input :password
        f.input :password_confirmation
      end
      f.actions
    end
  end
end
