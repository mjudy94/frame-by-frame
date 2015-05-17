require 'redis'

class Canvas
  @@redis = Redis.new(:host => "45.56.99.120", :port => 6379,:password => Rails.configuration.redis_password )

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
