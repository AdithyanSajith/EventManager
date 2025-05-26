module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :redirect_if_authenticated, only: [:new, :create] #prevents login users to sign up
    before_action :configure_permitted_parameters, only: [:create, :update] #allow custom fields while signup and update

    # POST /resource
    def create
      build_resource(sign_up_params)

      if resource.save
        assign_userable(resource)
        sign_up(resource_name, resource)
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

    def redirect_if_authenticated
      redirect_to filtered_events_path, alert: "You are already signed in." if user_signed_in?
    end

    def configure_permitted_parameters
      extra_fields = %i[
        name role interest city birthdate
        organisation website number bio
      ]
      devise_parameter_sanitizer.permit(:sign_up, keys: extra_fields)
      devise_parameter_sanitizer.permit(:account_update, keys: extra_fields)
    end

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

    def after_update_path_for(resource)
      flash[:notice] = "Profile updated successfully."
      edit_user_registration_path
    end

    def after_sign_up_path_for(resource)
      resource.role == "host" ? host_dashboard_path : choose_category_path
    end

    def assign_userable(user)
      return if user.userable.present?

      userable = case user.role
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
                 else
                   nil
                 end

      if userable
        user.update!(userable: userable)
      else
        user.destroy # Clean up invalid role signups
        flash[:alert] = "Invalid role selected."
        redirect_to new_user_registration_path
      end
    end
  end
end
