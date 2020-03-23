class FixerApiService
  BASE_URL = Settings[:fixer_api][:base_url]
  ACCESS_KEY = Settings[:fixer_api][:access_key]

  # @raise [JSON::ParserError, Faraday::ConnectionFailed]
  # @return [Hash]
  def get_currency!
    raw_body = Faraday.new(url: BASE_URL, params: {access_key: ACCESS_KEY})
                   .get('/api/latest').body
    body = JSON.parse raw_body
    body[:warning] = "Unfortunately, we cannot provide rates for custom currency due to the service's free plan"
    body.except('success', 'timestamp')
  end
end