require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module NewApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'pt-BR'

    # Prevent initializing your application and connecting to the database
    config.assets.initialize_on_precompile = false

    # Authentication configuration for ActionMailer
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_settings = {
      address:   ENV['SMTP_ADDRESS'],
      port:      ENV['SMTP_PORT'] || 587,
      domain:    ENV['SMTP_DOMAIN'],
      user_name: ENV['SMTP_USERNAME'],
      password:  ENV['SMTP_PASSWORD'],
      authentication: :plain,
      enable_starttls_auto: false
    }

    # HTML generated for form fields with error
    config.action_view.field_error_proc = Proc.new do |html_tag|
      html_tag.html_safe
    end

    # Be sure to have the adapter's gem in your Gemfile
    # and follow the adapter's specific installation
    # and deployment instructions.
    config.active_job.queue_adapter = :sidekiq
  end
end
