class ChannelSubscriptions
  def self.redis
    @redis ||= Redis.new
  end

  def self.clear(channel)
    redis.hkeys(channel).each { |key| redis.hdel(channel, key) } 
  end

  def self.all(channel)
    redis.hkeys(channel)
  end

  def self.add(channel, connection_string)
    redis.hincrby(channel, connection_string, 1)
  end

  def self.remove(channel, connection_string)
    redis.hincrby(channel, connection_string, -1)

    if redis.hget(channel, connection_string).to_i <= 0
      redis.hdel(channel, connection_string)
    end
  end

  def self.connected?(channel, connection_string)
    redis.hexists(channel, connection_string) && redis.hget(channel, connection_string).to_i > 0
  end
end
