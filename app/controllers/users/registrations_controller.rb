module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :redirect_if_authenticated, only: [:new, :create]
    before_action :configure_permitted_parameters, only: [:create, :update]

    # POST /resource
    def create
      build_resource(sign_up_params)

      if resource.save
        sign_up(resource_name, resource)
        assign_userable(resource) # Create host/participant based on role
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    # PATCH/PUT /resource
    def update
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      resource_updated = update_resource(resource, account_update_params)
      yield resource if block_given?

      if resource_updated
        set_flash_message_for_update(resource, prev_unconfirmed_email)
        bypass_sign_in resource, scope: resource_name
        redirect_to after_update_path_for(resource)
      else
        clean_up_passwords resource
        respond_with resource
      end
    end

    protected

    # Prevent already signed-in users from accessing signup
    def redirect_if_authenticated
      if user_signed_in?
        redirect_to filtered_events_path, alert: "You are already signed in."
      end
    end

    # Permit additional fields during sign up and update
    def configure_permitted_parameters
      extra_fields = [
        :name, :role, :interest, :city, :birthdate,
        :organisation, :website, :number, :bio
      ]
      devise_parameter_sanitizer.permit(:sign_up, keys: extra_fields)
      devise_parameter_sanitizer.permit(:account_update, keys: extra_fields)
    end

    # Skip password requirement if password not changed
    def update_resource(resource, params)
      if params[:password].present?
        super
      else
        params.delete(:password)
        params.delete(:password_confirmation)
        params.delete(:current_password)
        resource.update_without_password(params)
      end
    end

    # Redirect after updating profile
    def after_update_path_for(resource)
      flash[:notice] = "Profile updated successfully."
      edit_user_registration_path
    end

    # Redirect after signup based on role
    def after_sign_up_path_for(resource)
      resource.role == "host" ? host_dashboard_path : choose_category_path
    end

    # Automatically create and associate Host or Participant model
    def assign_userable(user)
      userable =
        case user.role
        when "host"
          Host.create!(
            organisation: user.organisation,
            website: user.website,
            bio: user.bio,
            number: user.number
          )
        when "participant"
          Participant.create!(
            name: user.name,
            interest: user.interest,
            city: user.city,
            birthdate: user.birthdate
          )
        end

      user.update!(userable: userable)
    end
  end
end
