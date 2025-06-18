module Users
  class RegistrationsController < Devise::RegistrationsController #Handles user registration and profile management
    before_action :redirect_if_authenticated, only: [:new, :create] #prevents login users to sign up
    before_action :configure_permitted_parameters, only: [:create, :update] #allow custom fields while signup and update
    skip_before_action :authenticate_user!, only: [:new, :create] # Allow unauthenticated users to access new and create actions

    # POST /resource
    def create # Handles user registration
      build_resource(sign_up_params)
      begin
        # Only use permitted userable fields for the selected role
        userable_params = permitted_userable_params
        case resource.role
        when "host"
          host_fields = %i[organisation website bio number]
          host_params = userable_params.slice(*host_fields.map(&:to_s))
          required = host_fields.map { |f| host_params[f.to_s] }
          if required.any?(&:blank?)
            flash.now[:alert] = "All host fields (organisation, website, bio, number) must be present."
            clean_up_passwords resource
            render :new, status: :unprocessable_entity and return
          end
          userable = Host.new(host_params)
        when "participant"
          participant_fields = %i[name interest city birthdate]
          participant_params = userable_params.slice(*participant_fields.map(&:to_s))
          # Name is on user, so get from resource
          participant_params["name"] = resource.name
          required = participant_fields.map { |f| participant_params[f.to_s] }
          if required.any?(&:blank?)
            flash.now[:alert] = "All participant fields (name, interest, city, birthdate) must be present."
            clean_up_passwords resource
            render :new, status: :unprocessable_entity and return
          end
          userable = Participant.new(participant_params)
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

      # Extract userable params from the form
      userable_params = params[:userable] || {}
      flash.now[:alert] = "Before update: name=#{resource.name}, params name=#{account_update_params[:name]}"
      resource_updated = update_resource(resource, account_update_params)
      flash.now[:notice] = "After update: name=#{resource.name}"
      yield resource if block_given?

      # Always sync participant name if role is participant
      if resource.userable.present? && resource.role == "participant"
        resource.userable.update(name: resource.name)
      end

      # Update userable fields if present and userable exists
      if resource.userable.present? && userable_params.present?
        case resource.role
        when "participant"
          resource.userable.update(
            interest: userable_params[:interest],
            city: userable_params[:city],
            birthdate: userable_params[:birthdate]
          )
        when "host"
          resource.userable.update(
            organisation: userable_params[:organisation],
            website: userable_params[:website],
            bio: userable_params[:bio]
          )
        end
      end

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
      resource.role == "host" ? host_dashboard_path : filtered_events_path
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

    private

    def permitted_userable_params
      params.fetch(:userable, {}).permit(:organisation, :website, :bio, :number, :name, :interest, :city, :birthdate)
    end
  end
end
