# Helper module to demonstrate various toast notification types
module ToastrExamplesHelper
  # Show examples of all notification types
  # This is useful for development and testing purposes
  def show_toastr_examples
    html = []
    html << %q{
      <div class="card my-3">
        <div class="card-header">Toastr Notification Examples</div>
        <div class="card-body">
          <p class="card-text">Click the buttons below to see different types of notifications.</p>
          <div class="btn-group" role="group">
            <button class="btn btn-success btn-sm me-2" onclick="toastr.success('This is a success message!')">Success</button>
            <button class="btn btn-info btn-sm me-2" onclick="toastr.info('This is an info message!')">Info</button>
            <button class="btn btn-warning btn-sm me-2" onclick="toastr.warning('This is a warning message!')">Warning</button>
            <button class="btn btn-danger btn-sm me-2" onclick="toastr.error('This is an error message!')">Error</button>
            <button class="btn btn-primary btn-sm" onclick="demoAllNotifications()">Show All</button>
          </div>
        </div>
      </div>
      <script>
        function demoAllNotifications() {
          setTimeout(() => toastr.success('Success notification example'), 300);
          setTimeout(() => toastr.info('Info notification example'), 1000);
          setTimeout(() => toastr.warning('Warning notification example'), 1700);
          setTimeout(() => toastr.error('Error notification example'), 2400);
        }
      </script>
    }
    html.join.html_safe
  end

  # Generate an example toast notification with custom options
  def toastr_demo_with_options(type, message, title = nil, options = {})
    type = type.to_sym
    valid_types = [:success, :info, :warning, :error]
    type = :info unless valid_types.include?(type)
    
    options_str = options.map { |k, v| "#{k}: #{v.is_a?(String) ? "'#{v}'" : v}" }.join(', ')
    
    javascript = if title.present?
                   "toastr.#{type}('#{message}', '#{title}', {#{options_str}});"
                 else
                   "toastr.#{type}('#{message}', '', {#{options_str}});"
                 end
    
    javascript.html_safe
  end
end
