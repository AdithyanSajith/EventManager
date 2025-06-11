# Controller concern for handling snackbar notifications
module SnackbarNotifier
  extend ActiveSupport::Concern
  
  included do
    before_action :prepare_snackbar_from_session
    after_action :clear_snackbar_data
  end
  
  private
  
  # Prepare snackbar data from session to be passed to the view
  def prepare_snackbar_from_session
    # Check for different types of snackbar data in session
    @snackbar_data = {}
    
    if session[:payment_snackbar].present?
      @snackbar_data = {
        type: 'payment',
        action: session[:payment_snackbar][:action],
        details: session[:payment_snackbar][:details]
      }
    elsif session[:registration_snackbar].present?
      @snackbar_data = {
        type: 'registration',
        action: session[:registration_snackbar][:action],
        details: session[:registration_snackbar][:details]
      }
    elsif session[:review_snackbar].present?
      @snackbar_data = {
        type: 'review',
        action: session[:review_snackbar][:action],
        details: session[:review_snackbar][:details]
      }
    elsif session[:ticket_snackbar].present?
      @snackbar_data = {
        type: 'ticket',
        action: session[:ticket_snackbar][:action],
        details: session[:ticket_snackbar][:details]
      }
    end
  end
  
  # Clear snackbar data from session after it's been processed
  def clear_snackbar_data
    session.delete(:payment_snackbar)
    session.delete(:registration_snackbar)
    session.delete(:review_snackbar)
    session.delete(:ticket_snackbar)
  end

  # Set a single snackbar in session, clearing all others
  def set_single_snackbar(type, action:, details:)
    %i[payment_snackbar registration_snackbar review_snackbar ticket_snackbar].each do |key|
      session.delete(key)
    end
    session["#{type}_snackbar".to_sym] = { action: action, details: details }
  end
end
