class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Set the default locale, in part, required for Devise
  # http://www.rubydoc.info/github/plataformatec/devise/master/ActionDispatch/Routing/Mapper%3Adevise_for
  def self.default_url_options
    { locale: I18n.locale }
  end

  protected

  def configure_permitted_parameters
    # TODO: Implement this in derived controllers to configure permitted
    # parameters before any actions take place.
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
