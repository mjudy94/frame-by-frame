require "redis"
require "nokogiri"

class Canvas
  @@redis = Redis.new

  def incoming(message, callback)
    channel = message['channel']

    # Ignore everything that is not a draw publication
    unless channel.start_with?('/draw')
      return callback.call(message)
    end

    redisKey = "room:#{message['ext']['room_id']}"

    case message['data']['action']
    when 'sketch'
      @@redis.append(redisKey, message['data']['svg'])
    when 'erase'
      svg_string = @@redis.get redisKey
      fragment = Nokogiri::HTML.fragment svg_string
      message['data']['data']['ids'].each do |id|
        fragment.at_css("\##{id}").remove
      end
      @@redis.set(redisKey, fragment.to_html)
    end

    callback.call(message)
  end
end
