class ErrorsController < ApplicationController
  def unauthorized
    @error = HttpError.new(:unauthorized, helpers.error_redirect_to)
    helpers.log_http_error(@error)
    render action: :error
  end

  def not_found
    @error = HttpError.new(:not_found, helpers.error_redirect_to)
    helpers.log_http_error(@error)
    render action: :error
  end

  def not_acceptable
    @error = HttpError.new(:not_acceptable, helpers.error_redirect_to)
    helpers.log_http_error(@error)
    render action: :error
  end

  def internal_server_error
    @error = HttpError.new(:internal_server_error, helpers.error_redirect_to)
    helpers.log_http_error(@error)
    render action: :error
  end

  protected

  def error
    render template: 'errors'
  end
end
