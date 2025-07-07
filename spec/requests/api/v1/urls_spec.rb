require 'rails_helper'

RSpec.describe "Api::V1::Urls", type: :request do
  let(:api_client) { create(:api_client, name: 'Test Client') }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{api_client.api_token}"
    }
  end

  describe "POST /api/v1/encode" do
    context "with valid URL" do
      it "creates a new short URL" do
        post "/api/v1/encode",
          params: { url: "https://example.com" }.to_json,
          headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to include("short_url")

        url_created = Url.find_by(original_url: "https://example.com")
        expect(url_created).to be_present
        expect(url_created.short_code).to be_present
      end
    end

    context "when URL already exists" do
      it "returns the existing short URL" do
        url = create(:url, :with_hashids_short_code, original_url: "https://example.com")
        post "/api/v1/encode",
          params: { url: "https://example.com" }.to_json,
          headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["short_url"]).to include(url.short_code)
      end
    end

    context "with missing URL param" do
      it "returns 400 bad request" do
        post "/api/v1/encode",
          params: {}.to_json,
          headers: headers

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid token" do
      it "returns 401 unauthorized" do
        bad_headers = headers.merge("Authorization" => "Bearer invalidtoken")

        post "/api/v1/encode",
          params: { url: "https://example.com" }.to_json,
          headers: bad_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/decode" do
    context "with valid short code" do
      it "returns the original URL" do
        url = create(:url, :with_hashids_short_code, original_url: "https://example.com")
        post "/api/v1/decode",
          params: { short_url: url.short_code }.to_json,
          headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to eq({ "original_url" => "https://example.com" })
      end
    end

    context "when short code does not exist" do
      it "returns 404 not found" do
        post "/api/v1/decode",
          params: { short_url: "nonexistent" }.to_json,
          headers: headers

        expect(response).to have_http_status(:not_found)
        body = JSON.parse(response.body)
        expect(body["error"]).to eq("Short code not found")
      end
    end

    context "when short code format is invalid" do
      it "returns 422 unprocessable entity" do
        post "/api/v1/decode",
          params: { short_url: "!@#$%" }.to_json,
          headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end
    end

    context "with missing short_url param" do
      it "returns 400 bad request" do
        post "/api/v1/decode",
          params: {}.to_json,
          headers: headers

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid token" do
      it "returns 401 unauthorized" do
        bad_headers = headers.merge("Authorization" => "Bearer invalidtoken")

        post "/api/v1/decode",
          params: { short_url: "abc123" }.to_json,
          headers: bad_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end


end
