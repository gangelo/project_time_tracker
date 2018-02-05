class HttpError
  attr_reader :http_status_symbol
  attr_reader :http_status
  attr_reader :http_status_message
  attr_reader :redirect_to

  def initialize(http_status_symbol, http_status, http_status_message, redirect_to)
    @http_status_symbol = http_status_symbol
    @http_status = http_status
    @http_status_message = http_status_message
    @redirect_to = redirect_to
  end
end
