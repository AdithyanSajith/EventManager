module Users
  class RegistrationsController < Devise::RegistrationsController #Handles user registration and profile management
    before_action :redirect_if_authenticated, only: [:new, :create] #prevents login users to sign up
    before_action :configure_permitted_parameters, only: [:create, :update] #allow custom fields while signup and update

    # POST /resource
    def create # Handles user registration
      build_resource(sign_up_params)
      begin
        # Build userable before saving user
        case resource.role
        when "host"
          required = [resource.organisation, resource.website, resource.bio, resource.number]
          if required.any?(&:blank?)
            flash.now[:alert] = "All host fields (organisation, website, bio, number) must be present."
            clean_up_passwords resource
            render :new, status: :unprocessable_entity and return
          end
          userable = Host.new(
            organisation: resource.organisation,
            website: resource.website,
            bio: resource.bio,
            number: resource.number
          )
        when "participant"
          required = [resource.name, resource.interest, resource.city, resource.birthdate]
          if required.any?(&:blank?)
            flash.now[:alert] = "All participant fields (name, interest, city, birthdate) must be present."
            clean_up_passwords resource
            render :new, status: :unprocessable_entity and return
          end
          userable = Participant.new(
            name: resource.name,
            interest: resource.interest,
            city: resource.city,
            birthdate: resource.birthdate
          )
        else
          flash.now[:alert] = "Invalid role selected."
          clean_up_passwords resource
          render :new, status: :unprocessable_entity and return
        end

        ActiveRecord::Base.transaction do # Ensure both user and userable are saved together
          userable.save!
          resource.userable = userable
          resource.save!
        end

        flash[:notice] = "Sign up successful! Welcome to Event Manager."
        if resource.active_for_authentication? # Check if the user is active
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource) # Sign in the user after successful registration
          respond_with resource, location: after_sign_up_path_for(resource) # Redirect to appropriate path after sign up
        else
          set_flash_message! :notice, "signed_up_but_#{resource.inactive_message}" # User is inactive
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      rescue ActiveRecord::RecordInvalid => e
        flash.now[:alert] = e.record.errors.full_messages.to_sentence.presence || e.message # Handle validation errors
        clean_up_passwords resource
        render :new, status: :unprocessable_entity
      rescue => e # Handle any other exceptions
        flash.now[:alert] = e.message.presence || "Registration failed."
        clean_up_passwords resource
        render :new, status: :unprocessable_entity
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

      case user.role
      when "host"
        required = [user.organisation, user.website, user.bio, user.number]
        if required.any?(&:blank?)
          raise "All host fields (organisation, website, bio, number) must be present."
        end
        userable = Host.create!(
          organisation: user.organisation,
          website: user.website,
          bio: user.bio,
          number: user.number
        )
      when "participant"
        required = [user.name, user.interest, user.city, user.birthdate]
        if required.any?(&:blank?)
          raise "All participant fields (name, interest, city, birthdate) must be present."
        end
        userable = Participant.create!(
          name: user.name,
          interest: user.interest,
          city: user.city,
          birthdate: user.birthdate
        )
      else
        raise "Invalid role selected."
      end

      user.update!(userable: userable)
    end
  end
end
