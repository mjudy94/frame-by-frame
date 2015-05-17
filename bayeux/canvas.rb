require "redis"
require "oga"

class Canvas
  @@redis = Redis.new

  def incoming(message, callback)
    channel = message['channel']

    # Ignore everything that is not a draw publication
    unless channel.start_with?('/draw')
      return callback.call(message)
    end

    room_id = message['ext']['room_id']

    case message['data']['action']
    when 'sketch'
      @@redis.append("room:#{room_id}", message['data']['svg'])
    when 'erase'
      canvas = @@redis.get("room:#{room_id}")
      message['data']['data']['ids'].each do |id|
        svg = Oga.parse_xml canvas
        canvas = ""
        svg.xpath("*[@id!='" << id << "']").each do |elem|
          canvas << elem.to_xml
        end
      end
      @@redis.set("room:#{room_id}", canvas)
    end

    callback.call(message)
  end
end
