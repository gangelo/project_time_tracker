class HttpError
  attr_reader :http_status_code_symbol
  attr_reader :http_status_code
  attr_reader :http_status_code_message
  attr_reader :redirect_to

  def initialize(http_status_code_symbol, redirect_to = root_path)
    @http_status_code_symbol = http_status_code_symbol
    @http_status_code =
      Rack::Utils::SYMBOL_TO_STATUS_CODE[@http_status_code_symbol]
    @http_status_code_message =
      Rack::Utils::HTTP_STATUS_CODES[@http_status_code]
    @redirect_to = redirect_to
  end

  def attributes
    { http_status_code: http_status_code,
      http_status_code_symbol: http_status_code_symbol,
      http_status_code_message: http_status_code_message,
      redirect_to: redirect_to }
  end
end
