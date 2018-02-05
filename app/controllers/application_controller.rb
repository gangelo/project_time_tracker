class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # TODO: Implement this in derived controllers to configure permitted
    # parameters before any actions take place.
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
