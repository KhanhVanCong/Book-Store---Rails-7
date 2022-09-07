# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout 'authentication'

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #  super
  # end

  # POST /resource/sign_in
  def create
    # super
    flash.now[:notice] = "welcome"
    puts notice
    redirect_to forgot_password_path
  end

  # DELETE /resource/sign_out
  # def destroy
  #   redirect_to login_path
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
