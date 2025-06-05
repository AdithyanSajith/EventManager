class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> {
    request.format.json? || request.format.turbo_stream?
  } #Enable CSRF protection for all except JSON and Turbo Stream requests

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  helper_method :current_resource_owner

  if Rails.env.development?
    skip_before_action :verify_authenticity_token, if: -> {
      devise_controller? && params[:controller] == "users/sessions" ||
      request.format.turbo_stream?
    }
  end

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.is_a?(AdminUser)

    case resource.role
    when 'participant'
      participant = resource.userable
      participant&.interest.blank? ? choose_category_path : filtered_events_path
    when 'host'
      host_dashboard_path
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
    redirect_to root_path, alert: "Only hosts can access this section." unless current_resource_owner&.role == 'host'
  end

  def authenticate_resource_owner!
    if doorkeeper_token&.accessible?
      doorkeeper_authorize!
    else
      authenticate_user!
    end
  end

  def current_resource_owner
    doorkeeper_token&.accessible? ? User.find(doorkeeper_token.resource_owner_id) : current_user
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # Handle 404
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def render_not_found(exception = nil)
    if request.format.json? || request.path.start_with?('/api/')
      render json: { error: "Resource not found" }, status: :not_found
    else
      raise exception if exception
      render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    end
  end

  # Handle error 500
  #rescue_from StandardError do |e|
   # logger.error e.message
    #logger.error e.backtrace.join("\n")
    #render json: { error: "Internal server error" }, status: :internal_server_error
  #end
end
