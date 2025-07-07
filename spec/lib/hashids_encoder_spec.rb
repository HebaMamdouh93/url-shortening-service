require 'rails_helper'

RSpec.describe HashidsEncoder do
  let(:encoder) { described_class }

  describe '.encode' do
    it 'encodes an integer ID to a non-empty string' do
      result = encoder.encode(123)
      expect(result).to be_a(String)
      expect(result).not_to be_empty
    end

    it 'produces different codes for different IDs' do
      code1 = encoder.encode(1)
      code2 = encoder.encode(2)
      expect(code1).not_to eq(code2)
    end
  end

  describe '.decode' do
    it 'decodes a code back to the original integer ID' do
      id = 456
      code = encoder.encode(id)
      decoded_id = encoder.decode(code)

      expect(decoded_id).to eq(id)
    end

    it 'returns nil for an invalid or malformed code' do
      expect(encoder.decode('invalidcode')).to be_nil
    end

    it 'returns nil for an empty string' do
      expect(encoder.decode('')).to be_nil
    end

    it 'returns nil for nil input' do
      expect(encoder.decode(nil)).to be_nil
    end
  end
end
