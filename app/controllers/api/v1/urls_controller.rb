class Api::V1::UrlsController < ApplicationController

  # POST api/v1/encode
  def encode
    short_url = UrlShortener::Encode.new(original_url: url_params).call
    render json: { short_url: }
  end

  # POST api/v1/decode
  def decode
    original_url = UrlShortener::Decode.new(code: short_url_params.to_s).call
    render json: { original_url: }
  end

  private
  def url_params
    params.require(:url)
  end

  def short_url_params
    params.require(:short_url)
  end
end
