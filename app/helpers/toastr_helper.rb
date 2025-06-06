# Helper module for toast notifications
module ToastrHelper
  # Maps Rails flash types to Toastr notification types
  def map_flash_to_toastr(flash_type)
    case flash_type.to_sym
    when :notice, :success
      'success'
    when :alert, :error
      'error'
    when :warning
      'warning'
    else
      'info'
    end
  end

  # Generates the JavaScript for Toastr notifications
  def toastr_flash_messages
    flash_messages = []
    flash.each do |type, message|
      if message.is_a?(Array)
        message.each do |individual_message|
          flash_messages << toastr_js_for(type, individual_message)
        end
      else
        flash_messages << toastr_js_for(type, message)
      end
    end
    flash_messages.join("\n").html_safe
  end

  private  def toastr_js_for(flash_type, message, options = {})
    toastr_type = map_flash_to_toastr(flash_type)
    
    # Determine if the message should be treated as HTML
    # Default to false for security reasons
    allow_html = flash_type.to_s.end_with?('_html') 
    
    # Determine toast style (snackbar or regular)
    is_snackbar = flash_type.to_s.end_with?('_snackbar')
    
    # Ensure message is a string
    message = message.to_s
    
    # Set options based on type
    options_hash = {}
    
    if is_snackbar
      # Default snackbar options
      options_hash = {
        "positionClass" => "toast-bottom-center",
        "timeOut" => "3000",
        "extendedTimeOut" => "1000",
        "closeButton" => false,
        "tapToDismiss" => true
      }
    end
    
    # Merge with any provided options
    options_hash.merge!(options) if options.present?
    
    # Convert options to JavaScript string if present
    options_str = options_hash.present? ? 
      ", {#{options_hash.map { |k, v| "#{k}: #{v.is_a?(String) ? "'#{v}'" : v}" }.join(', ')}}" : 
      ""
    
    # Build the toastr options and message
    if allow_html
      # For HTML content, we still escape JavaScript but allow HTML to render
      "toastr.#{toastr_type}('#{escape_javascript(message)}', ''#{options_str});"
    else
      # For regular messages, escape both JavaScript and HTML
      safe_message = ActionController::Base.helpers.sanitize(message)
      "toastr.#{toastr_type}('#{escape_javascript(safe_message)}', ''#{options_str});"
    end
  end
end
