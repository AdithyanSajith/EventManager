// Process snackbar notifications from session
document.addEventListener("turbo:load", () => {
  // Check if there are any snackbar notifications in the session
  const snackbarData = document.querySelector('meta[name="snackbar-data"]');
  if (snackbarData) {
    try {
      const data = JSON.parse(snackbarData.getAttribute('content'));
      if (data && data.type && data.action) {
        setTimeout(() => {
          switch (data.type) {
            case 'payment':
              processPaymentSnackbar(data);
              break;
            case 'registration':
              processRegistrationSnackbar(data);
              break;
            case 'review':
              processReviewSnackbar(data);
              break;
            case 'ticket':
              processTicketSnackbar(data);
              break;
          }
        }, 500); // Small delay to ensure toastr is fully loaded
      }
    } catch (e) {
      console.error("Error processing snackbar data:", e);
    }
  }
});

// Process payment snackbars
function processPaymentSnackbar(data) {
  const options = {
    positionClass: "toast-bottom-center",
    timeOut: "3000",
    progressBar: true
  };
  
  switch (data.action) {
    case 'success':
      showSnackbar('success', data.details || 'Payment successful!', options);
      break;
    case 'pending':
      showSnackbar('info', data.details || 'Payment processing...', options);
      break;
    case 'error':
      showSnackbar('error', data.details || 'Payment failed', options);
      break;
    case 'refund':
      showSnackbar('success', data.details || 'Refund processed', options);
      break;
  }
}

// Process registration snackbars
function processRegistrationSnackbar(data) {
  const options = {
    positionClass: "toast-bottom-center",
    timeOut: "3000",
    progressBar: true
  };
  
  switch (data.action) {
    case 'success':
      showSnackbar('success', data.details || 'Successfully registered!', options);
      break;
    case 'cancelled':
      showSnackbar('warning', data.details || 'Registration cancelled', options);
      break;
    case 'error':
      showSnackbar('error', data.details || 'Registration failed', options);
      break;
  }
}

// Process review snackbars
function processReviewSnackbar(data) {
  const options = {
    positionClass: "toast-bottom-center",
    timeOut: "3000",
    progressBar: true
  };
  
  switch (data.action) {
    case 'submitted':
      showSnackbar('success', data.details || 'Review submitted!', options);
      break;
    case 'updated':
      showSnackbar('info', data.details || 'Review updated', options);
      break;
    case 'deleted':
      showSnackbar('warning', data.details || 'Review deleted', options);
      break;
    case 'error':
      showSnackbar('error', data.details || 'Review action failed', options);
      break;
  }
}

// Process ticket snackbars
function processTicketSnackbar(data) {
  const options = {
    positionClass: "toast-bottom-center",
    timeOut: "3000",
    progressBar: true
  };
  
  switch (data.action) {
    case 'issued':
      showSnackbar('success', data.details || 'Ticket issued!', options);
      break;
    case 'downloaded':
      showSnackbar('info', data.details || 'Ticket downloaded', options);
      break;
    case 'error':
      showSnackbar('error', data.details || 'Ticket error', options);
      break;
  }
}

// Generic function to show a snackbar with toastr
function showSnackbar(type, message, options = {}) {
  // Save current toastr options
  const originalOptions = { ...toastr.options };
  
  // Apply snackbar options
  Object.keys(options).forEach(key => {
    toastr.options[key] = options[key];
  });
  
  // Show the notification
  toastr[type](message);
  
  // Restore original options
  setTimeout(() => {
    toastr.options = originalOptions;
  }, 500);
}
