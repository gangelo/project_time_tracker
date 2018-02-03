module DeviseHelper
  def devise_error_messages!
    ResourceMessageBuilder.build_html_errors(resource, 'errors.messages.not_saved',
      resource: resource.class.model_name.human.downcase)
  end
end
