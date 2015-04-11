require 'yaml'

# Loads the decrypted credentials file into a global constant
CREDENTIALS = YAML.load_file(Rails.root.join('config', 'creds.yml'))
