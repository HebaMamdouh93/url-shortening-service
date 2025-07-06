require 'rails_helper'

RSpec.describe UrlShortener::Encode do
  include CacheKeyHelper

  let(:encoder) { class_double(Base62Encoder) }
  let(:cache) { class_double(CacheService) }
  let(:original_url) { 'https://example.com' }
  let(:service) { described_class.new(original_url: original_url, encoder: encoder, cache: cache) }
  let(:code) { 'abc123' }
  let(:existing_url) { create(:url, original_url: original_url, short_code: "existing123") }

  describe '#call' do
    context 'when URL already exists' do
      it 'returns the full short URL and does not create a new record' do
        existing_url 
        result = service.call

        expect(result).to eq("#{ENV['BASE_URL']}/existing123")
        expect(Url.where(original_url: original_url).count).to eq(1)
      end
    end

    context 'when URL does not exist' do
      before do
        allow(encoder).to receive(:encode).and_return(code)
        allow(cache).to receive(:write)
      end

      it 'creates a new Url, encodes the id, updates short_code, writes to cache, and returns full URL' do
        expect {
          result = service.call
          expect(result).to eq("#{ENV['BASE_URL']}/#{code}")
        }.to change { Url.count }.by(1)

        new_url = Url.last
        expect(new_url.original_url).to eq(original_url)
        expect(new_url.short_code).to eq(code)
        expect(encoder).to have_received(:encode).with(new_url.id)
        expect(cache).to have_received(:write).with(short_code_cache_key(code), original_url)
      end
    end

    context 'when creating URL raises validation error' do
      it 'raises a ShortenerError' do
        invalid_service = described_class.new(original_url: nil, encoder: encoder, cache: cache)

        expect {
          invalid_service.call
        }.to raise_error(ShortenerError)
      end
    end
  end
end
