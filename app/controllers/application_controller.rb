class ApplicationController < ActionController::Base
  # Skip CSRF verification for API requests
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  # Before actions for Devise controllers
  before_action :configure_permitted_parameters, if: :devise_controller? # Allow extra params
  before_action :store_user_location!, if: :storable_location? # Valid locations redirections

  # Make current_resource_owner accessible in views
  helper_method :current_resource_owner

  # Skip CSRF for Devise logout in development (for convenience)
  if Rails.env.development?
    skip_before_action :verify_authenticity_token, if: -> {
      devise_controller? && params[:controller] == "users/sessions" && params[:action] == "destroy"
    }
  end

  # Skip CSRF for all Devise session controller actions (sign_in, sign_out, etc.)
  skip_before_action :verify_authenticity_token, if: -> {
    devise_controller? && params[:controller] == 'users/sessions'
  }

  # Redirect after sign in based on role
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

  # Redirect after sign up based on role
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  protected

  # Configure extra permitted parameters for Devise
  def configure_permitted_parameters
    added_attrs = [:name, :role, :interest, :city, :birthdate, :number, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  # Authenticate that the user is a host
  def authenticate_host!
    authenticate_user!
    redirect_to root_path, alert: "Only hosts can access this section." unless current_resource_owner&.role == 'host'
  end

  private

  # Check if the location is storable for redirecting
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  # Store user location for redirection
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # Get the current resource owner based on the Doorkeeper token or Devise session
  def current_resource_owner
    if doorkeeper_token
      User.find(doorkeeper_token.resource_owner_id)
    else
      current_user
    end
  end

  # Handle ActiveRecord::RecordNotFound exceptions with JSON response for API requests
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # Render a "not found" response for API requests
  def render_not_found(exception = nil)
    if request.format.json? || request.path.start_with?('/api/')
      render json: { error: "Resource not found" }, status: :not_found
    else
      # Fallback to default HTML error page for non-API requests
      raise exception if exception
      render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    end
  end
end
