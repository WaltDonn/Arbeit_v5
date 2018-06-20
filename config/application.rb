require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ArbeitV5
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Explicitly remove CSRF protections
    config.action_view.embed_authenticity_token_in_remote_forms = false
    config.action_controller.allow_forgery_protection = false
    #config.action_controller.default_protect_from_forgery = false
  end
end
