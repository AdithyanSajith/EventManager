//= require toastr
//= require_tree .
// Show toastr notifications for Rails flash messages
document.addEventListener('DOMContentLoaded', function() {
  if (typeof toastr !== 'undefined') {
    var notice = document.querySelector('.flash-notice');
    var alert = document.querySelector('.flash-alert');
    var error = document.querySelector('.flash-error');
    if (notice) {
      toastr.success(notice.textContent);
    }
    if (alert) {
      toastr.error(alert.textContent);
    }
    if (error) {
      toastr.error(error.textContent);
    }
  }
});