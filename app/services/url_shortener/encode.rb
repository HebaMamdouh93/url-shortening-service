module UrlShortener
  class Encode
    include CacheKeyHelper
    def initialize(original_url:, encoder: HashidsEncoder, cache: CacheService)
      @original_url = original_url
      @encoder = encoder
      @cache = cache
    end

    def call
      url = Url.find_by(original_url: @original_url)
      return full_url(url.short_code) if url

      ActiveRecord::Base.transaction do
        url = Url.create!(original_url: @original_url)
        code = @encoder.encode(url.id)
        url.update!(short_code: code)
        @cache.write(short_code_cache_key(code), url.original_url)
        full_url(code)
      end
    rescue ActiveRecord::RecordInvalid => e
      raise ShortenerError, e.message
    end

    private

    def full_url(code)
      "#{ENV['BASE_URL']}/#{code}"
    end
  end
end
