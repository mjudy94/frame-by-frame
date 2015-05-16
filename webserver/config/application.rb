require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'yaml'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webserver
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config/application.rb
    config.action_mailer.delivery_method = :aws_sdk
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Loads the decrypted credentials file into a global constant
    creds = YAML.load_file(Rails.root.join('config', 'creds.yml'))
    config.db_username = creds["db"]["username"]
    config.db_password = creds["db"]["password"]
    config.secret_key_base = creds["secret_key_base"]

    config.s3_access_key_id = creds["s3"]["access_key_id"]
    config.s3_secret_access_key = creds["s3"]["secret_access_key"]
    config.s3_bucket = 'frame-by-frame'
    # Aws.config.update({
    #   region: 'us-east-1',
    #   credentials: Aws::Credentials.new(creds["s3"]["access_key_id"], creds["s3"]["secret_access_key"])
    # })

  end
end


require 'net/smtp'

module Net
  class SMTP
    def tls?
      true
    end
  end
end
