module ApplicationHelper
  # Returns the authenticated user if one is logged in, or a blank new user if not.
  def resource
    current_user || User.new
  end

  def current_user?
    current_user
  end

  alias authenticated? current_user?

  # Paging
  def pager_per_page
    per_page = session[:per_page] || 10
  end

  def pager_page_entries_info(collection)
    if collection.respond_to?(:model_name) || model_class.respond_to?(:model_name)
      model_class = collection.respond_to?(:model_name) ?
         collection.model_name :
         collection.first.model_name.class
      model = model_class.human.titleize
      entries_info = case
      when collection.total_entries == 0
        "No <strong>#{model.pluralize}</strong> found."
      when collection.total_entries == 1
        "Displaying <strong>1</strong> #{model}."
      when collection.total_pages == 1
        "Displaying <strong>all #{collection.total_entries}</strong> #{model.pluralize}"
      else
        "Displaying #{model.pluralize} <strong>#{collection.offset + 1} " +
        "- #{collection.offset + collection.length}</strong> " +
        "of <strong>#{number_with_delimiter collection.total_entries}</strong> in total"
      end
      entries_info.html_safe
    end
  end

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

  def log_http_warning(http_warning)
    raise ArgumentError if http_warning.blank?
    http_warning = { warning: http_warning } unless http_warning.respond_to?(:attributes)
    http_warning = http_warning.attributes if http_warning.respond_to?(:attributes)
    log_entry = create_log_entry(http_error)
    yield log_entry if block_given?
    write_log_entry(log_entry, "warning")
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
