class ApiClient < ApplicationRecord
  ##### Validations #####
  validates :name, presence: true 
  validates :api_token, presence: true, uniqueness: true
end
