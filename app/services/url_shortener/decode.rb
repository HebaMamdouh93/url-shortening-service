module UrlShortener
  class Decode
    include CacheKeyHelper
    def initialize(code:, encoder: Base62Encoder, cache: CacheService)
      @code = code
      @encoder = encoder
      @cache = cache
    end

    def call
      @cache.fetch(short_code_cache_key(@code)) do
        id = @encoder.decode(@code)
        url = Url.find_by(id: id)
        raise UrlNotFoundError, "Short code not found" unless url

        url.original_url
      end
    rescue ArgumentError
      raise ShortenerError, "Invalid short code format"
    end
  end
end
