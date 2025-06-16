ActiveAdmin.register Review do
  # ✅ Permit strong parameters
  permit_params :rating, :comment, :participant_id, :reviewable_type, :reviewable_id

  # ✅ Scopes
  scope :all
  scope("5-Star")      { |r| r.where(rating: 5) }
  scope("Low Ratings") { |r| r.where("rating <= 2") }

  # ✅ Filters
  filter :rating, as: :select, collection: 1..5
  filter :reviewable_type, as: :select, collection: ["Event", "Venue"]
  filter :created_at

  # ✅ Index
  index do
    selectable_column
    id_column
    column :rating
    column :comment
    column("Participant") { |r| r.participant.name rescue "-" }
    column :reviewable
    column :created_at
    actions
  end

  # ✅ Show
  show do
    attributes_table do
      row :rating
      row :comment
      row :participant
      row :reviewable_type
      row :reviewable
      row :created_at
      row :updated_at
    end
  end
end
