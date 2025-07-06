require 'base62-rb'

module Base62Encoder
  def self.encode(id)
    Base62.encode(id)
  rescue StandardError => e
    raise ShortenerError, e.message 
  end

  def self.decode(code)
    Base62.decode(code)
  rescue StandardError => e
    raise ShortenerError, e.message  
  end
end
