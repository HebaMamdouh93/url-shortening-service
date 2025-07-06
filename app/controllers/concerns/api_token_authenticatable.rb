module ApiTokenAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_with_api_token!
  end

  def authenticate_with_api_token!
    token = request.headers['Authorization']&.split(' ')&.last

    unless token && valid_token?(token)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    ApiClient.exists?(api_token: token)
  end
end
