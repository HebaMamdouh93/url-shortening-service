require 'rails_helper'
RSpec.describe Base62Encoder do
  subject { described_class }

  describe '.encode' do
    it 'encodes an integer to a base62 string' do
      expect(subject.encode(12345)).to eq(Base62.encode(12345))
    end

    it 'returns a string' do
      expect(subject.encode(123)).to be_a(String)
    end
  end

  describe '.decode' do
    it 'decodes a base62 string back to integer' do
      encoded = subject.encode(98765)
      expect(subject.decode(encoded)).to eq(98765)
    end

    it 'returns an integer' do
      expect(subject.decode('abc')).to be_a(Integer)
    end
  end

  describe 'encode-decode cycle' do
    it 'encodes and decodes back to the original number' do
      original_id = 123456789
      encoded = subject.encode(original_id)
      decoded = subject.decode(encoded)
      expect(decoded).to eq(original_id)
    end
  end
end