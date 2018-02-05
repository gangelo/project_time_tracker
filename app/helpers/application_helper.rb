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

  def log_information(information)
    log_entry = create_log_entry({ information: information })
    yield log_entry if block_given?
    write_log_entry(log_entry, "information")
  end

  def log_warning(warning)
    log_entry = create_log_entry({ warning: warning })
    yield log_entry if block_given?
    write_log_entry(log_entry, "warning")
  end

  def log_error(error)
    log_entry = create_log_entry({ error: error })
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

  def create_log_entry(info)
    log_entry = { date_time: DateTime.now.strftime,
      request_method: request.request_method, original_url: request.original_url,
      remote_ip: request.remote_ip, server_software: request.server_software }
    log_entry.merge(info) unless info.blank? || !info.is_a?(Hash)
  end
end
