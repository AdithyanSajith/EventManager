Doorkeeper.configure do
  # Authenticate resource owner using Devise current_user or fallback to warden
  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  # Support password grant flow: authenticate user by email and password
  resource_owner_from_credentials do |_routes|
    user = User.find_by(email: params[:username])
    if user&.valid_password?(params[:password])
      user
    else
      nil
    end
  end

  # Allowed OAuth grant flows
  grant_flows %w[authorization_code password client_credentials refresh_token]

  # Skip client authentication for password grant (for development/testing only)
  skip_client_authentication_for_password_grant true

  # Access token expiration time
  access_token_expires_in 2.hours

  # Admin interface access control — allow only logged-in hosts to manage OAuth apps
  admin_authenticator do |controller|
    user = controller.current_user
    if user.nil? || user.role != "host"
      controller.redirect_to main_app.root_path, alert: "Access denied."
    end
  end

  # Optional: Define scopes if you want scoped access control (commented out)
  # default_scopes  :public
  # optional_scopes :write, :update
end
