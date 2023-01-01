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

    redis.hdel(channel, connection_string) if redis.hget(channel, connection_string).to_i <= 0
  end

  def self.connected?(channel, connection_string)
    redis.hexists(channel, connection_string) && redis.hget(channel, connection_string).to_i.positive?
  end
end
