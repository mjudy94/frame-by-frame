require 'redis'

class Canvas
  @@redis = Redis.new(
    :port => 6379,
    :host => Rails.configuration.redis_host,
    :password => Rails.configuration.redis_password
  )

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
