require 'rails_helper'

RSpec.describe ApiClient, type: :model do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:api_token) }
    it { should validate_uniqueness_of(:api_token)}
end
