# Ensure ApplicationController's authenticate_user! is not run for ActiveAdmin controllers
ActiveSupport.on_load(:after_initialize) do
  if defined?(ActiveAdmin)
    ActiveAdmin::BaseController.skip_before_action :authenticate_user!, raise: false
  end
end
