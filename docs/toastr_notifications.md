# Notification System Documentation

## Overview

This document provides details on how to use the notification system integrated into the Event Manager application, featuring both Toastr and Snackbar-style notifications.

## Basic Usage

### Standard Toast Notifications

To display a standard toast notification in any controller:

```ruby
# Success notification
render_flash_message(:success, "Operation completed successfully")

# Info notification
render_flash_message(:info, "Here's some information")

# Warning notification
render_flash_message(:warning, "Warning: This action cannot be undone")

# Error notification
render_flash_message(:error, "An error occurred")
```

### Snackbar Notifications

To display a snackbar-style notification (appears at bottom of screen):

```ruby
# Using the snackbar helper directly
render_snackbar(:success, "Operation completed successfully")

# Or with the render_flash_message method and snackbar parameter
render_flash_message(:success, "Operation completed successfully", true)
```

### Traditional Rails Flash

The Toastr system also works with traditional Rails flash messages:

```ruby
flash[:notice] = "This will show as a success message"
flash[:alert] = "This will show as an error message"
```

## Advanced Features

### HTML Content in Notifications

To include HTML content in notifications, use the `_html` suffix:

```ruby
flash[:success_html] = "<strong>Success!</strong> Your changes have been saved."

# For HTML in snackbar notifications
flash[:success_html_snackbar] = "<strong>Success!</strong> Your changes have been saved."
```

### Action-Specific Helpers

For common actions, use these specialized notification methods:

```ruby
# Payment notifications
payment_snackbar(:success, "Payment of $99.99 processed!")
payment_snackbar(:pending, "Processing your payment...")
payment_snackbar(:error, "Payment failed: Invalid card")

# Registration notifications
registration_snackbar(:success, "You're registered for Ruby Conference")
registration_snackbar(:cancelled, "Registration cancelled")

# Review notifications
review_snackbar(:submitted, "Thanks for your feedback!")
review_snackbar(:updated, "Review has been updated")
review_snackbar(:deleted, "Review has been removed")

# Ticket notifications
ticket_snackbar(:issued, "Your ticket #ABC123 is ready")
ticket_snackbar(:downloaded, "Ticket downloaded")
```

### Session-Based Notifications

To show notifications after a redirect:

```ruby
# Store notification data in session
session[:payment_snackbar] = {
  action: :success,
  details: "Payment of $99.99 successfully processed!"
}

# Redirect to another page
redirect_to some_path
```

### Helper Methods

#### Sticky Notifications

```erb
<%= toastr_sticky(:info, "This is a sticky notification") %>
```

#### Confirmation Dialogs

```erb
<%= toastr_confirmation(
      "Are you sure you want to delete this item?",
      delete_path,
      "Yes, delete",
      "Cancel"
    ) %>
```

#### Countdown Notifications

```erb
<%= toastr_countdown(:warning, "This page will reload in:", 10) %>
```

## Demo Page

A demonstration page is available at `/toastr_demo` which shows all notification types and features.

## Configuration

The Toastr configuration is defined in `app/javascript/custom/toastr_setup.js` and includes:

- Responsive positioning based on screen size
- Progress bars
- Auto-dismiss timers (configurable)
- Click to dismiss functionality

## Implementation Details

### Files

- `app/helpers/toastr_helper.rb` - Core Toastr functionality
- `app/helpers/toastr_patterns_helper.rb` - Advanced notification patterns
- `app/helpers/snackbar_helper.rb` - Snackbar-style notifications
- `app/controllers/concerns/snackbar_notifier.rb` - Session-based notifications
- `app/javascript/custom/snackbar_processor.js` - Client-side snackbar handling
- `app/helpers/toastr_examples_helper.rb` - Demo utilities
- `app/javascript/custom/toastr_setup.js` - JavaScript configuration
- `config/initializers/toastr.rb` - Rails flash type registration

### Security

All notifications are sanitized by default to prevent XSS attacks. HTML content is only allowed when specifically requested using the `_html` suffix.
