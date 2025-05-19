module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      # Allow custom fields during sign up and account update
      additional_attrs = [:name, :role, :city, :birthdate, :interest, :phone]
      devise_parameter_sanitizer.permit(:sign_up, keys: additional_attrs)
      devise_parameter_sanitizer.permit(:account_update, keys: additional_attrs)
    end

    def after_sign_up_path_for(resource)
      if resource.role == "host"
        host_dashboard_path
      else
        choose_category_path
      end
    end
  end
end
