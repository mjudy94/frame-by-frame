require 'yaml'

# Loads the decrypted credentials file into a global constant
creds = YAML.load_file(Rails.root.join('config', 'creds.yml'))
Rails.application.config.db_username = creds["db"]["username"]
Rails.application.config.db_password = creds["db"]["password"]
