class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Allow Devise parameters if needed (e.g., name, username, etc.)
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Make current_host and current_participant accessible in views
  helper_method :current_host, :current_participant

  # Define the redirect path after sign in, based on the type of user
  def after_sign_in_path_for(resource)
    if resource.is_a?(Participant)
      if resource.interest.blank?
        choose_category_path
      else
        filtered_events_path
      end
    elsif resource.is_a?(Host)
      events_path
    else
      root_path
    end
  end

  protected

  # Permit extra parameters for Devise sign up and account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
