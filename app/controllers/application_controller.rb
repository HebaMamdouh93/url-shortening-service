class ApplicationController < ActionController::API
  include ApiTokenAuthenticatable
  include HandleExceptions
end
