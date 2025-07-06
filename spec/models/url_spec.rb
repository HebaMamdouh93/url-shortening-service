require 'rails_helper'

RSpec.describe Url, type: :model do
  it { should validate_presence_of(:original_url) }


  describe 'original_url format' do
    it 'is valid with a proper http URL' do
      url = build(:url, original_url: 'http://example.com')
      expect(url).to be_valid
    end

    it 'is valid with a proper https URL' do
      url = build(:url, original_url: 'https://example.com')
      expect(url).to be_valid
    end

    it 'is invalid with an invalid URL' do
      url = build(:url, original_url: 'ftp://example.com')
      expect(url).not_to be_valid
    end
  end


  it { should validate_uniqueness_of(:short_code).allow_nil }
end
