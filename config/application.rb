require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApp
  class Application < Rails::Application


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # Set autoload lib/ directry
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join( 'config', 'locales', '**', '*.{rb,yml}' ).to_s]
    # I18n.enforce_available_locales = true
    config.i18n.default_locale = :ja

    config.assets.precompile += %w( *.png *.jpg, *.jpeg *.git )
    config.assets.initialize_on_precompile = false



    # Paperclip
    config.paperclip_defaults = {
        storage: :azure_storage,
        path: ":class/:id/:attachment/:style/:filename",
        azure_credentials: {
          account_name: Rails.application.secrets.azure_credentials['account_name'],
          access_key: Rails.application.secrets.azure_credentials['access_key']
        },
        azure_container: "meshiya",
        url: ":azure_domain_url",
    }

  end
end
