require 'rails_helper'

RSpec.describe CacheService do
  let(:cache) { Rails.cache }
  let(:key) { 'test:key' }
  let(:value) { 'cached value' }

  before { cache.clear }

  describe '.write' do
    it 'writes a value to the cache with expiry' do
      expect(cache).to receive(:write).with(key, value, expires_in: CacheService::CACHE_EXPIRE)
      described_class.write(key, value)
    end
  end

  describe '.read' do
    it 'reads a value from the cache' do
      cache.write(key, value)
      expect(described_class.read(key)).to eq(value)
    end
  end

  describe '.fetch' do
    context 'when key exists' do
      it 'returns the cached value' do
        cache.write(key, value)
        result = described_class.fetch(key) { 'new value' }
        expect(result).to eq(value)
      end
    end

    context 'when key does not exist' do
      it 'writes and returns the block result' do
        result = described_class.fetch(key) { 'new value' }
        expect(result).to eq('new value')
        expect(cache.read(key)).to eq('new value')
      end
    end
  end
end
