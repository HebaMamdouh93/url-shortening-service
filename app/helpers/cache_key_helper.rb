module CacheKeyHelper
    def short_code_cache_key(code)
      "short_code:#{code}"
    end
end