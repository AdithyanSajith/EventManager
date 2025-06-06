# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # Redirect to login page after resending confirmation instructions
  def after_resending_confirmation_instructions_path_for(resource_name)
    new_session_path(resource_name)
  end

  # Redirect to login page after confirmation
  def after_confirmation_path_for(resource_name, resource)
    new_session_path(resource_name)
  end
end
