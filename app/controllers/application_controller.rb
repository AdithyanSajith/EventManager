class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_root_path
    elsif resource.respond_to?(:role)
      case resource.role
      when 'participant'
        resource.interest.blank? ? choose_category_path : filtered_events_path
      when 'host'
        host_dashboard_path
      else
        root_path
      end
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :role, :interest, :city, :birthdate, :number, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def authenticate_host!
    authenticate_user!
    unless current_user.role == 'host'
      redirect_to root_path, alert: "Only hosts can access this section."
    end
  end
end
