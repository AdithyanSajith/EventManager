# Add Toastr flash types to ActionController
ActionController::Base.class_eval do
  add_flash_types :success, :info, :warning, :error
end
