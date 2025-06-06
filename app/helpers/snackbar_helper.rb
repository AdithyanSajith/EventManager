# Helper module for snackbar-style notifications using Toastr
module SnackbarHelper
  include ActionView::Helpers::JavaScriptHelper
  
  # Show a snackbar notification for various actions
  def snackbar_notification(type, message, options = {})
    # Default options for snackbar style
    default_options = {
      "positionClass" => "toast-bottom-center",
      "timeOut" => "3000",
      "extendedTimeOut" => "1000",
      "closeButton" => false,
      "tapToDismiss" => true,
      "progressBar" => true,
      "preventDuplicates" => true,
      "showEasing" => "swing",
      "hideEasing" => "linear",
      "showMethod" => "slideDown", 
      "hideMethod" => "slideUp"
    }
    
    # Merge with any custom options
    merged_options = default_options.merge(options)
    
    # Convert options to JS format
    options_str = merged_options.map { |k, v| "#{k}: #{v.is_a?(String) ? "'#{v}'" : v}" }.join(", ")
    
    # Map notification type
    toastr_type = case type.to_sym
                  when :notice, :success
                    "success"
                  when :alert, :error
                    "error"
                  when :warning
                    "warning"
                  else
                    "info"
                  end
    
    # Build JavaScript for snackbar
    javascript = <<-JS
      (function() {
        var previousPosition = toastr.options.positionClass;
        var temp = Object.assign({}, toastr.options);
        toastr.options = { #{options_str} };
        toastr.#{toastr_type}('#{escape_javascript(message)}');
        toastr.options = temp;
      })();
    JS
    
    javascript.html_safe
  end
  
  # Payment-specific snackbar notifications
  def payment_snackbar(action, details = nil)
    case action
    when :success
      message = "✅ Payment successful! #{details}"
      snackbar_notification(:success, message)
    when :pending
      message = "⏳ Payment processing... #{details}"
      snackbar_notification(:info, message)
    when :error
      message = "❌ Payment failed: #{details || 'Please try again'}"
      snackbar_notification(:error, message)
    when :refund
      message = "💰 Refund processed: #{details}"
      snackbar_notification(:success, message)
    end
  end
  
  # Registration-specific snackbar notifications
  def registration_snackbar(action, details = nil)
    case action
    when :success
      message = "✅ Successfully registered! #{details}"
      snackbar_notification(:success, message)
    when :cancelled
      message = "🚫 Registration cancelled: #{details}"
      snackbar_notification(:warning, message)
    when :error
      message = "❌ Registration failed: #{details || 'Please try again'}"
      snackbar_notification(:error, message)
    end
  end
  
  # Review-specific snackbar notifications
  def review_snackbar(action, details = nil)
    case action
    when :submitted
      message = "✅ Review submitted! #{details}"
      snackbar_notification(:success, message)
    when :updated
      message = "✏️ Review updated: #{details}"
      snackbar_notification(:info, message)
    when :deleted
      message = "🗑️ Review deleted: #{details}"
      snackbar_notification(:warning, message)
    when :error
      message = "❌ Review action failed: #{details || 'Please try again'}"
      snackbar_notification(:error, message)
    end
  end
  
  # Ticket-specific snackbar notifications
  def ticket_snackbar(action, details = nil)
    case action
    when :issued
      message = "🎫 Ticket issued! #{details}"
      snackbar_notification(:success, message)
    when :downloaded
      message = "📥 Ticket downloaded: #{details}"
      snackbar_notification(:info, message)
    when :error
      message = "❌ Ticket error: #{details || 'Please try again'}"
      snackbar_notification(:error, message)
    end
  end
end
