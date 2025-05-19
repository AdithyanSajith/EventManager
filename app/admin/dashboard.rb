ActiveAdmin.register_page "Dashboard" do
  content do
    columns do
      column do
        panel "Recent Events" do
          ul do
            Event.order(created_at: :desc).limit(5).map do |event|
              li link_to(event.title, admin_event_path(event))
            end
          end
        end
      end

      column do
        panel "Recently Registered Users" do
          ul do
            User.order(created_at: :desc).limit(5).map do |user|
              li "#{user.name} (#{user.role})"
            end
          end
        end
      end
    end
  end
end
