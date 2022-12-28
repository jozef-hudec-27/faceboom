class ChannelSubscriptions
  REDIS_KEY = 'connected_nodes'

  def self.redis
    @redis ||= Redis.new
  end

  def self.clear
    redis.hkeys(REDIS_KEY).each { |key| redis.hdel(REDIS_KEY, key) } 
  end

  def self.all
    redis.hkeys(REDIS_KEY)
  end

  def self.add(connection_string)
    redis.hincrby(REDIS_KEY, connection_string, 1)
  end

  def self.remove(connection_string)
    redis.hincrby(REDIS_KEY, connection_string, -1)

    if redis.hget(REDIS_KEY, connection_string).to_i <= 0
      redis.hdel(REDIS_KEY, connection_string)
    end
  end

  def self.connected?(connection_string)
    redis.hexists(REDIS_KEY, connection_string) && redis.hget(REDIS_KEY, connection_string).to_i > 0
  end
end
