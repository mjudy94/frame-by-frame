require 'redis'

module Canvas
  @@redis = Redis.new

  def self.get room_id
    @@redis.get("room:#{room_id}") || ''
  end
end
