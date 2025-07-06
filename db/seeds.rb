ApiClient.find_or_create_by!(name: 'Test Client') do |client|
  api_token = "f22de332e9c829fc74907a533fa73a9a1d60a5383f64b5a64e05372879cf3ffa"

  client.api_token = api_token
end

puts "Test API client created:"
puts "  API Key: #{ApiClient.last.api_token}"
