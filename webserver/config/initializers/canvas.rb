require 'redis'

class Canvas
  @@redis = Redis.new

  def initialize room_id
    @key = "room:#{room_id}"
  end

  def get
    @@redis.get(@key) || ''
  end

  def clear
    @@redis.del @key
  end
end
