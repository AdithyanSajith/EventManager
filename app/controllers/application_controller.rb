class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.is_a?(Participant) && resource.interest.blank?
      choose_category_path
    elsif resource.is_a?(Participant)
      filtered_events_path
    elsif resource.is_a?(Host)
      events_path
    else
      root_path
    end
  end
end
