class ToastrDemoController < ApplicationController
  include SnackbarHelper
  def index
    # This view will show example notifications
  end
  
  def trigger
    notification_type = params[:type] || 'info'
    notification_style = params[:style] || 'toast'
    
    # Process based on notification type and style
    case notification_type
    when 'success'
      if notification_style == 'snackbar'
        render_snackbar(:success, "This is a success snackbar!")
      else
        render_flash_message(:success, "This is a success notification!")
      end
    when 'info'
      if notification_style == 'snackbar'
        render_snackbar(:info, "This is an info snackbar!")
      else
        render_flash_message(:info, "This is an info notification!")
      end
    when 'warning'
      if notification_style == 'snackbar'
        render_snackbar(:warning, "This is a warning snackbar!")
      else
        render_flash_message(:warning, "This is a warning notification!")
      end
    when 'error'
      if notification_style == 'snackbar'
        render_snackbar(:error, "This is an error snackbar!")
      else
        render_flash_message(:error, "This is an error notification!")
      end
    when 'all'
      if notification_style == 'snackbar'
        render_snackbar(:success, "Success snackbar example")
        render_snackbar(:info, "Info snackbar example")
        render_snackbar(:warning, "Warning snackbar example")
        render_snackbar(:error, "Error snackbar example")
      else
        render_flash_message(:success, "Success notification example")
        render_flash_message(:info, "Info notification example")
        render_flash_message(:warning, "Warning notification example")
        render_flash_message(:error, "Error notification example")
      end
    when 'html'
      # Use _html suffix to enable HTML content
      if notification_style == 'snackbar'
        flash[:success_html_snackbar] = "<strong>HTML Content</strong> in snackbar with <em>formatting</em>!"
      else
        flash[:success_html] = "<strong>HTML Content</strong> in notification with <em>formatting</em>!"
      end
    when 'payment'
      # Simulate payment-related notification
      session[:payment_snackbar] = { action: :success, details: "Payment of $99.99 successfully processed!" }
    when 'registration'
      # Simulate registration-related notification
      session[:registration_snackbar] = { action: :success, details: "Successfully registered for Ruby Conference" }
    when 'review'
      # Simulate review-related notification
      session[:review_snackbar] = { action: :submitted, details: "Thank you for your feedback" }
    when 'ticket'
      # Simulate ticket-related notification
      session[:ticket_snackbar] = { action: :issued, details: "Ticket #ABC123 is ready" }
    when 'sticky'
      # This will be handled by the view using toastr_sticky helper
    end
    
    redirect_to toastr_demo_path
  end
  
  def simulate_action
    action_type = params[:action_type] || 'payment'
    
    case action_type
    when 'payment'
      @snackbar_js = payment_snackbar(:success, "Payment processed immediately!")
    when 'registration'
      @snackbar_js = registration_snackbar(:success, "Registered for event!")
    when 'review'
      @snackbar_js = review_snackbar(:submitted, "Thanks for your review!")
    when 'ticket'
      @snackbar_js = ticket_snackbar(:issued, "Your ticket is ready!")
    end
    
    render :index
  end
end
