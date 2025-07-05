class CacheService
  CACHE_EXPIRE = 24.hours

  def self.read(key)
    Rails.cache.read(key)
  end

  def self.write(key, value)
    Rails.cache.write(key, value, expires_in: CACHE_EXPIRE)
  end

  def self.fetch(key)
    Rails.cache.fetch(key, expires_in: CACHE_EXPIRE) { yield }
  end
end