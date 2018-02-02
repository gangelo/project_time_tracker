# more info: http://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html
#
# This class inherits from the default FormBuilder class and adds two public methods
# for displaying errors related to specific fields.
#
# Copied from Dan Matthews (https://github.com/bluefocus) Twetter project on github
# (https://github.com/Thinkful/twetter).
#
class InlineErrorsBuilder < ActionView::Helpers::FormBuilder

  # Generates HTML for displaying errors related to the attribute passed as 'meth'
  #
  def errors_for(meth, options = {})
    if has_errors?(meth)
      innerHtml = @template.content_tag(:i, nil, class: 'fa fa-times-circle', style: 'margin-right:8px;') + @object.errors[meth].join('<br/>').capitalize#.html_safe
      @template.content_tag(:div, innerHtml, class: 'input-lg alert alert-danger', role: 'alert')
    end
  end

  # Adds the 'has-error' class to the list of other classes passed if there are
  # errors on the attribute passed as 'meth'
  #
  def validation_class(meth, *klasses)
    klasses << 'has-error' if has_errors?(meth)
    klasses.compact.join(' ').html_safe
  end

  private

  # Determines if there are errors on the attribute passed as 'meth'. Includes protection
  # against edge cases where there is no object present.
  #
  def has_errors?(meth)
    @object.present? ? @object.errors[meth].present? : false
  end
end
