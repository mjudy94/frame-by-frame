require "redis"
require 'yaml'
class Canvas

credsFile = YAML.load_file('creds.yml')
redis_password = credsFile.fetch('redis')['password']

  @@redis = Redis.new(:host => "45.56.99.120", :port => 6379,:password => redis_password)


  def incoming(message, callback)
    channel = message['channel']

    # Ignore everything that is not a draw publication
    unless channel.start_with?('/draw')
      return callback.call(message)
    end

    room_id = message['ext']['room_id']
    @@redis.append("room:#{room_id}", message['data']['svg'])

    callback.call(message)
  end
end
