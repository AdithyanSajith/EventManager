//= require jquery
//= require toastr
//= require datepicker_min_today
//= require_tree .
// Show toastr notifications for Rails flash messages
function showToastrFromFlash() {
  if (typeof toastr !== 'undefined') {
    var notice = document.querySelector('.flash-notice');
    var alert = document.querySelector('.flash-alert');
    var error = document.querySelector('.flash-error');
    if (notice && notice.textContent.trim() !== "") {
      toastr.success(notice.textContent.trim());
      notice.remove();
    }
    if (alert && alert.textContent.trim() !== "") {
      toastr.error(alert.textContent.trim());
      alert.remove();
    }
    if (error && error.textContent.trim() !== "") {
      toastr.error(error.textContent.trim());
      error.remove();
    }
  }
}

document.addEventListener('DOMContentLoaded', showToastrFromFlash);
document.addEventListener('turbo:load', showToastrFromFlash);