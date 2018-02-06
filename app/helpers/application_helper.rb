module ApplicationHelper
  # Returns the authenticated user if one is logged in, or a blank new user if not.
  def resource
    current_user || User.new
  end

  def current_user?
    current_user
  end

  alias authenticated? current_user?

  def error_redirect_to
    request.referrer || root_path
  end

  def log_http_error(http_error)
    raise ArgumentError if http_error.nil?
    raise ArgumentError unless http_error.respond_to?(:attributes)
    log_entry = create_log_entry(http_error.attributes)
    yield log_entry if block_given?
    write_log_entry(log_entry, "error")
  end

  def write_log_entry(log_entry, delimiter)
    delimiter = delimiter.upcase
    delimiter_start = "$#{delimiter}_START"
    delimiter_end = "$#{delimiter}_END"
    Rails.logger.warn("#{delimiter_start}#{log_entry}#{delimiter_end}")
  end

  private

  def create_log_entry(log_info)
    raise ArgumentError if log_info.blank?
    raise ArgumentError unless log_info.is_a?(Hash)
    log_entry = { date_time: DateTime.now.strftime,
                  request_method: request.request_method,
                  original_url: request.original_url,
                  remote_ip: request.remote_ip,
                  server_software: request.server_software }
    log_entry.merge(log_info)
  end
end
