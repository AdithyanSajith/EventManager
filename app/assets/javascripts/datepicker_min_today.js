// Ensure jQuery is loaded and DOM is ready
$(document).on('turbo:load DOMContentLoaded', function() {
  // Target all date fields for event creation
  var today = new Date();
  var yyyy = today.getFullYear();
  var mm = String(today.getMonth() + 1).padStart(2, '0');
  var dd = String(today.getDate()).padStart(2, '0');
  var minDate = yyyy + '-' + mm + '-' + dd;

  // Set min attribute for all date fields
  $("input[type='date'][name*='event[starts_at]']").attr('min', minDate);
  $("input[type='date'][name*='event[ends_at]']").attr('min', minDate);

  // If a custom datepicker is used, add config here (example for jQuery UI Datepicker):
  if ($.fn.datepicker) {
    $("input[type='date'][name*='event[starts_at]']").datepicker('option', 'minDate', 0);
    $("input[type='date'][name*='event[ends_at]']").datepicker('option', 'minDate', 0);
  }
});
