require 'yaml'

# Loads the decrypted credentials file into a global constant
creds = YAML.load_file(Rails.root.join('config', 'creds.yml'))
ENV["DB_USERNAME"] = creds["db"]["username"]
ENV["DB_PASSWORD"] = creds ["db"]["password"]
