Doorkeeper.configure do
  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  resource_owner_from_credentials do |_routes|
    user = User.find_by(email: params[:username])
    user if user&.valid_password?(params[:password])
  end

  grant_flows %w[authorization_code password client_credentials refresh_token]
  skip_client_authentication_for_password_grant true
  access_token_expires_in 2.hours

  # ✅ Strong AdminUser restriction for Doorkeeper UI
  admin_authenticator do |controller|
    if controller.respond_to?(:current_admin_user)
      unless controller.current_admin_user
        controller.redirect_to main_app.new_admin_user_session_path, alert: "Please sign in as admin."
        throw(:halt)
      end
    else
      # If not using ActiveAdmin controller, fallback
      controller.redirect_to main_app.root_path, alert: "Access denied."
      throw(:halt)
    end
  end
end
