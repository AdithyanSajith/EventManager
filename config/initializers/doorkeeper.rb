Doorkeeper.configure do
  # Authenticate resource owner with Devise's current_user or fallback
  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  # This is required for password grant flow to work
  resource_owner_from_credentials do |_routes|
    user = User.find_by(email: params[:username])
    if user && user.valid_password?(params[:password])
      user
    else
      nil
    end
  end

  # Support grant flows you want
  grant_flows %w[authorization_code password client_credentials refresh_token]

  # Skip client authentication for password grant (for development/testing only)
  skip_client_authentication_for_password_grant true

  # Enforce access token expiration if you want
  access_token_expires_in 2.hours

  # Optional scopes
  # default_scopes  :public
  # optional_scopes :write, :update
end
