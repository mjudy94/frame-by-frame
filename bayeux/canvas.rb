require "redis"
require "oga"
require "yaml"

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
