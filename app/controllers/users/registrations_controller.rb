module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :redirect_if_authenticated, only: [:new, :create]
    before_action :configure_permitted_parameters, only: [:create, :update]

    protected

    def redirect_if_authenticated
      redirect_to filtered_events_path, alert: "You are already signed in." if user_signed_in?
    end

    def configure_permitted_parameters
      additional_attrs = [
        :name, :role, :city, :birthdate, :interest,
        :number, :organisation, :website, :bio
      ]
      devise_parameter_sanitizer.permit(:sign_up, keys: additional_attrs)
      devise_parameter_sanitizer.permit(:account_update, keys: additional_attrs)
    end

    # ✅ Handles update without password when password fields are blank
    def update_resource(resource, params)
      if params[:password].present?
        super
      else
        params.delete(:password)
        params.delete(:password_confirmation)
        params.delete(:current_password) # ✅ remove virtual param
        resource.update_without_password(params)
      end
    end

    # ✅ Stay on the edit page and show success message
    def after_update_path_for(resource)
      flash[:notice] = "Profile updated successfully."
      edit_user_registration_path
    end

    def after_sign_up_path_for(resource)
      resource.role == "host" ? host_dashboard_path : choose_category_path
    end
  end
end
