# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout "users/default" #, only: [:edit]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
    puts 'In Users::SessionsController#create'
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
  end
end
