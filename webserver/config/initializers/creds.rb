require 'yaml'

# Loads the decrypted credentials file into a global constant
creds = YAML.load_file(Rails.root.join('config', 'creds.yml'))
Rails.configuration.db_username = creds["db"]["username"]
Rails.configuration.db_password = creds["db"]["password"]
