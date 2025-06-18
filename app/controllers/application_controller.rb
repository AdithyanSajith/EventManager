class ApplicationController < ActionController::Base
  include SnackbarNotifier
  
  protect_from_forgery with: :exception, unless: -> {
    request.format.json? || request.format.turbo_stream?
  } #Enable CSRF protection for all except JSON and Turbo Stream requests

  before_action :configure_permitted_parameters, if: :devise_controller? # Ensure Devise parameters are permitted for sign up and account update
  before_action :authenticate_user!, unless: :devise_admin_controller? # Ensure user is authenticated for all actions except ActiveAdmin
  before_action :authenticate_host!, if: -> { controller_name == 'hosts' } # Ensure only hosts can access host-related actions
  before_action :authenticate_resource_owner!, if: -> { doorkeeper_token.present? } # Authenticate resource owner for API requests
  before_action :store_user_location!, if: :storable_location? # Store user location for after sign in

  helper_method :current_resource_owner

  if Rails.env.development? # Skip CSRF verification for specific requests in development
    skip_before_action :verify_authenticity_token, if: -> {
      devise_controller? && params[:controller] == "users/sessions" ||
      request.format.turbo_stream?
    }
  end

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.is_a?(AdminUser)

    case resource.userable_type
    when 'Participant'
      participant = resource.userable
      participant&.interest.blank? ? choose_category_path : filtered_events_path # Redirect to filtered events if interest is set
    when 'Host'
      hosted_events_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource) # Redirect after sign up
    after_sign_in_path_for(resource)
  end

  protected # Configure Devise parameters for sign up and account update

  def configure_permitted_parameters # This method allows additional parameters to be accepted during user sign up and account update
    added_attrs = [:name, :interest, :city, :birthdate, :number, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def authenticate_host! # Ensure only hosts can access host-related actions
    authenticate_user!
    redirect_to root_path, alert: "Only hosts can access this section." unless current_resource_owner&.userable.present?
  end

  def authenticate_resource_owner! # Authenticate resource owner for API requests
    if doorkeeper_token&.accessible?
      doorkeeper_authorize!
    else
      authenticate_user!
    end
  end

  def current_resource_owner # Determine the current resource owner based on the Doorkeeper token or current user
    doorkeeper_token&.accessible? ? User.find(doorkeeper_token.resource_owner_id) : current_user
  end

  def ensure_participant!
    # Allow admin users to access participant-only actions
    if defined?(current_admin_user) && current_admin_user
      return true
    end
    # For regular users, ensure they are participants
    unless current_user && current_user.userable_type == "Participant"
      render_flash_message(:error, "Only participants can access this section.")
      # Optionally show a snackbar for unauthorized userable type
      session[:registration_snackbar] = {
        action: :error,
        details: "Only participants can access this section."
      }
      redirect_to root_path
    end
  end

  private

  def devise_admin_controller? # Check if the current controller is an ActiveAdmin controller
    is_a?(ActiveAdmin::BaseController) || (defined?(ActiveAdmin) && self.class < ActiveAdmin::BaseController)
  end

  # For Devise redirection
  def storable_location? # Check if the location can be stored for after sign in
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location! # Store the user's location for after sign in
    store_location_for(:user, request.fullpath) if storable_location?
  end

  # Current user handling
  def current_resource_owner # Determine the current resource owner, prioritizing admin user if available
    current_admin_user || current_user
  end

  # Only show one flash message per type (success, error, etc.)
  def flash_message(type, text) # Store flash messages in an array
    flash[type] = [text]
  end

  def render_flash_message(type, text, as_snackbar = false) # Render a flash message based on the type and text provided
    # Apply snackbar suffix if requested
    type = "#{type}_snackbar".to_sym if as_snackbar # Convert type to a symbol with snackbar suffix if requested
    
    case type
    when :notice, :success, :success_snackbar # Handle different flash message types
      flash_message(as_snackbar ? :success_snackbar : :success, text)
    when :alert, :error, :error_snackbar
      flash_message(as_snackbar ? :error_snackbar : :error, text)
    when :warning, :warning_snackbar
      flash_message(as_snackbar ? :warning_snackbar : :warning, text)
    else
      flash_message(as_snackbar ? :info_snackbar : :info, text)
    end
  end
  
  # Helper specifically for snackbar-style notifications
  def render_snackbar(type, text)
    render_flash_message(type, text, true)
  end

  # Handle 404
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found # Render a 404 page when a record is not found

  def render_not_found(exception = nil) # Render a 404 page for not found errors
    if request.format.json? || request.path.start_with?('/api/')
      render json: { error: "Resource not found" }, status: :not_found # Render JSON response for API requests
    else
      raise exception if exception
      render file: Rails.public_path.join('404.html'), status: :not_found, layout:  # false
    end
  end

  # Handle error 500
  rescue_from StandardError do |e| # Handle any standard error and render a 500 page
    logger.error e.message
    logger.error e.backtrace.join("\n")
    if request.format.json? || request.path.start_with?('/api/') #
      render json: { error: "Internal server error" }, status: :internal_server_error
    else
      render file: Rails.public_path.join('500.html'), status: :internal_server_error, layout: false
    end
  end
end
