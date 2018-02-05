class ErrorsController < ApplicationController
  def unauthorized
    helpers.log_error(:unauthorized)
    @error = HttpError.new(:unauthorized, 401, titleize_error(:unauthorized),
                           helpers.error_redirect_to)
    render action: :error
  end

  def not_found
    helpers.log_error(:not_found)
    @error = HttpError.new(:not_found, 404, titleize_error(:not_found),
                            helpers.error_redirect_to)
    render action: :error
  end

  def not_acceptable
    helpers.log_error(:not_acceptable)
    @error = HttpError.new(:not_acceptable, 406,
                           titleize_error(:not_acceptable),
                           helpers.error_redirect_to)
    render action: :error
  end

  def internal_server_error
    helpers.log_error(:internal_server_error)
    @error = HttpError.new(:internal_server_error, 500,
                           titleize_error(:internal_server_error),
                           helpers.error_redirect_to)
    render action: :error
  end

  protected

  def error
    render template: 'errors'
  end

  def titleize_error(http_status_code_symbol)
    http_status_code_symbol.to_s.titleize
  end
end
