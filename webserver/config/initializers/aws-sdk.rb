# config/initializers/aws-sdk.rb
Aws.config[:credentials] = Aws::Credentials.new('key', 'secret')
