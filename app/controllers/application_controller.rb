class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller? # Allow extra params
  before_action :store_user_location!, if: :storable_location? # Valid locations redirections

  # ✅ Only skip CSRF for Devise logout in development
  if Rails.env.development?
    skip_before_action :verify_authenticity_token, if: -> {
      devise_controller? &&
      params[:controller] == "users/sessions" &&
      params[:action] == "destroy"
    }
  end

  # ⚠️ Skip CSRF verification for all Devise sessions controller actions (sign_in, sign_out, etc.)
  skip_before_action :verify_authenticity_token, if: -> {
    devise_controller? && params[:controller] == 'users/sessions'
  }

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_root_path
    elsif resource.respond_to?(:role)
      case resource.role
      when 'participant'
        participant = resource.userable
        participant&.interest.blank? ? choose_category_path : filtered_events_path
      when 'host'
        host_dashboard_path
      else
        root_path
      end
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :role, :interest, :city, :birthdate, :number, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def authenticate_host!
    authenticate_user!
    redirect_to root_path, alert: "Only hosts can access this section." unless current_resource_owner.role == 'host'
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # Added method to get the current user from Doorkeeper token
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
