require "redis"

class Canvas
  @@redis = Redis.new

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
