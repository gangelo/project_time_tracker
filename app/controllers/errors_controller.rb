class ErrorsController < ApplicationController
  def unauthorized
    logger_entry = format_logger_entry(:unauthorized)
    Rails.logger.info(logger_entry)
  end

  def not_found
    logger_entry = format_logger_entry(:not_found)
    Rails.logger.info(logger_entry)
  end

  def not_acceptable
    logger_entry = format_logger_entry(:not_acceptable)
    Rails.logger.info(logger_entry)
  end

  def internal_server_error
    logger_entry = format_logger_entry(:internal_server_error)
    Rails.logger.info(logger_entry)
  end

  private

  def format_logger_entry(error)
    original_url = request.original_url
    remote_ip = request.remote_ip
    request_method = request.request_method
    server_software = request.server_software

    { error: error, request_method: request_method, original_url: original_url,
      remote_ip: remote_ip, server_software: server_software }
  end
end
