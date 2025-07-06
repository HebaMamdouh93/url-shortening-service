module HandleExceptions
  extend ActiveSupport::Concern

  included do
    rescue_from ShortenerError, with: :render_shortener_error
    rescue_from UrlNotFoundError, with: :render_not_found
  end

  private

  def render_shortener_error(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end

  def render_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
