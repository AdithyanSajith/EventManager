# Helper module that adds useful patterns and enhanced functionality to toastr notifications
module ToastrPatternsHelper
  # Show a confirmation toast with a callback action
  def toastr_confirmation(message, action_url, action_text = "Confirm", cancel_text = "Cancel")
    js = <<-JS
      toastr.info(
        '#{escape_javascript(message)}' + 
        '<div class="mt-2 d-flex justify-content-between">' +
        '  <a href="#{action_url}" class="btn btn-sm btn-primary">#{action_text}</a>' +
        '  <button onclick="toastr.clear()" class="btn btn-sm btn-secondary">#{cancel_text}</button>' +
        '</div>',
        '', 
        { 
          timeOut: 0,
          extendedTimeOut: 0,
          closeButton: true,
          tapToDismiss: false,
          escapeHtml: false
        }
      );
    JS
    js.html_safe
  end

  # Show a sticky notification that persists until user dismisses it
  def toastr_sticky(type, message, title = nil)
    toastr_type = case type.to_sym
                  when :notice, :success then 'success'
                  when :alert, :error then 'error' 
                  when :warning then 'warning'
                  else 'info'
                  end
    
    title_param = title.present? ? "'#{escape_javascript(title)}'" : "''"
    
    js = <<-JS
      toastr.#{toastr_type}(
        '#{escape_javascript(message)}',
        #{title_param},
        { 
          timeOut: 0,
          extendedTimeOut: 0,
          closeButton: true,
          tapToDismiss: false
        }
      );
    JS
    js.html_safe
  end
  
  # Show a toast with countdown to auto-dismiss
  def toastr_countdown(type, message, countdown_seconds = 10)
    toastr_type = case type.to_sym
                  when :notice, :success then 'success'
                  when :alert, :error then 'error' 
                  when :warning then 'warning'
                  else 'info'
                  end
    
    js = <<-JS
      (function() {
        let seconds = #{countdown_seconds};
        const countdownToast = toastr.#{toastr_type}(
          '#{escape_javascript(message)} <span class="countdown-timer badge bg-secondary">' + seconds + 's</span>',
          '', 
          { 
            timeOut: #{countdown_seconds * 1000},
            extendedTimeOut: 0,
            closeButton: true,
            tapToDismiss: true,
            escapeHtml: false
          }
        );
        
        const interval = setInterval(function() {
          seconds--;
          if (seconds <= 0) {
            clearInterval(interval);
            return;
          }
          $('.countdown-timer').text(seconds + 's');
        }, 1000);
      })();
    JS
    js.html_safe
  end
end
