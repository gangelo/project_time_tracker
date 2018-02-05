require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CovermymedsDevisePundit
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Load our validators for use in our models.
    config.eager_load_paths << Rails.root.join('app/validators')

    # Load all the code in our lib.
    config.autoload_paths += %W(#{config.root}/lib)

    # Handle errors a better way.
    # This configures a Rack app to be called when an error that we haven't
    # handled is produced.
    config.exceptions_app = self.routes

    # Note: any errors not normally handled by rails need to be added here, and
    # associated with the http error that should handle it. These ultimately
    # will be routed to the ErrorsController through the rails routes.rb
    # (see the above config.exceptions_app setting).
    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :unauthorized
  end
end
