require 'rails_helper'

RSpec.describe UrlShortener::Decode do
  include CacheKeyHelper

  let(:code) { 'abc123' }
  let(:encoder) { class_double(Base62Encoder) }
  let(:cache) { class_double(CacheService) }

  subject(:service) { described_class.new(code: code, encoder: encoder, cache: cache) }

  describe '#call' do
    context 'when original URL is found in cache' do
      it 'returns the cached original URL' do
        allow(cache).to receive(:fetch).with(short_code_cache_key(code)).and_return('https://example.com')

        result = service.call

        expect(result).to eq('https://example.com')
        expect(encoder).not_to receive(:decode)
      end
    end

    context 'when original URL is not in cache but exists in DB' do
      let(:url) { create(:url, original_url: 'https://example.com') }

      it 'decodes the code, finds the URL, caches it, and returns original URL' do
        allow(cache).to receive(:fetch).with(short_code_cache_key(code)).and_yield
        allow(encoder).to receive(:decode).with(code).and_return(url.id)

        result = service.call

        expect(result).to eq('https://example.com')
        expect(encoder).to have_received(:decode).with(code)
      end
    end

    context 'when decoded ID is not found in DB' do
      it 'raises UrlNotFoundError' do
        allow(cache).to receive(:fetch).with(short_code_cache_key(code)).and_yield
        allow(encoder).to receive(:decode).with(code).and_return(-1)

        expect {
          service.call
        }.to raise_error(UrlNotFoundError, /Short code not found/)
      end
    end

    context 'when code format is invalid and decode raises ArgumentError' do
      it 'raises ShortenerError' do
        allow(cache).to receive(:fetch).with(short_code_cache_key(code)).and_yield
        allow(encoder).to receive(:decode).with(code).and_raise(ArgumentError)

        expect {
          service.call
        }.to raise_error(ShortenerError, /Invalid short code format/)
      end
    end
  end
end
