// Custom toastr setup
document.addEventListener("turbo:load", () => {
  // Determine best position based on screen size
  const isMobile = window.innerWidth < 768;
  
  // Toastr configuration with responsive settings
  toastr.options = {
    closeButton: true,
    debug: false,
    newestOnTop: true,
    progressBar: true,
    positionClass: isMobile ? "toast-top-full-width" : "toast-top-right",
    preventDuplicates: true,
    onclick: null,
    showDuration: "300",
    hideDuration: "1000",
    timeOut: "5000",
    extendedTimeOut: "1000",
    showEasing: "swing",
    hideEasing: "linear",
    showMethod: "fadeIn",
    hideMethod: "fadeOut",
    // Allow clicking on toast to dismiss it
    tapToDismiss: true
  };
  
  // Handle window resize events for responsive toast positioning
  window.addEventListener('resize', () => {
    const isMobile = window.innerWidth < 768;
    toastr.options.positionClass = isMobile ? "toast-top-full-width" : "toast-top-right";
  });
});
