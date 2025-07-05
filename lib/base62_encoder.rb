require 'base62-rb'

module Base62Encoder
  def self.encode(id)
    Base62.encode(id)
  end

  def self.decode(code)
    Base62.decode(code)
  end
end
