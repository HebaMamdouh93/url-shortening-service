# app/lib/hashids_encoder.rb
require 'hashids'

module HashidsEncoder
  def self.encoder
    @encoder ||= Hashids.new(
      ENV.fetch('HASHID_SALT', 'default_salt'),
      6 # min length of short code
    )
  end

  def self.encode(id)
    encoder.encode(id)
  end

  def self.decode(code)
    decoded = encoder.decode(code)
    decoded.first if decoded.any?
  end
end
