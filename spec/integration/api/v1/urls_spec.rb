require 'swagger_helper'

RSpec.describe 'URL Shortener APIS', type: :request do
  let(:api_client) { create(:api_client, name: 'API Client 1') }
  let(:Authorization) { "Bearer #{api_client.api_token}" }
  let(:url) { create(:url, :with_short_code ) }

  path '/api/v1/encode' do
    post 'Encodes a long URL' do
      tags 'URL Shortener APIs'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          url: { type: :string, example: 'https://example.com' }
        },
        required: ['url']
      }

      response '200', 'Shortened URL returned' do
        schema type: :object,
               properties: {
                 short_url: { type: :string, example: 'http://localhost:3000/abc123' }
               }

        let(:body) { { url: 'https://example.com' } }
        run_test!
      end

      response '400', 'Bad Request (missing params)' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'param is missing or the value is empty: url' }
               }

        let(:body) { {} }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Unauthorized' }
               }
        let(:Authorization) { 'Bearer invalidtoken' }
        let(:body) { { url: 'https://example.com' } }
        run_test!
      end

      response '422', 'Unprocessable Entity (ShortenerError)' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid URL' }
               }

        let(:body) { { url: 'invalid-url' } }
        run_test!
      end
    end
  end


   path '/api/v1/decode' do
    post 'Decode a short URL' do
      tags 'URL Shortener'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    short_url: { type: :string, example: 'abc123' }
                  },
                  required: ['short_url']
                }

      response '200', 'Original URL returned' do
      
        schema type: :object,
               properties: {
                 original_url: { type: :string, example: 'https://example.com' }
               }

        let(:body) { { short_url: url.short_code } }
        run_test!
      end

      response '400', 'Bad Request (missing params)' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'param is missing or the value is empty: short_url' }
               }

        let(:body) { {} }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Unauthorized' }
               }
        let(:Authorization) { 'Bearer invalidtoken' }
        let(:body) { { short_url: 'abc123' } }
        run_test!
      end

      response '404', 'URL not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Short code not found' }
               }

        let(:body) { { short_url: 'notfound' } }
        run_test!
      end

      response '422', 'Invalid short code format' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid short code format' }
               }

        let(:body) { { short_url: '!@#$%' } }
        run_test!
      end
    end
  end
end
