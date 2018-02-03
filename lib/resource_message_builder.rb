#module CovermymedsDevisePundit
  class ResourceMessageBuilder
    def self.build_html_errors(resource, i18n_key = 'errors.messages.generic', i18n_args = {})
      ResourceMessageBuilder.build_errors(resource, :html, i18n_key, i18n_args)
    end

    private

    def self.build_errors(resource, format = :html, i18n_key = 'errors.messages.generic', i18n_args = {})
      raise ArgumentError, 'resource is nil' if resource.nil?
      raise ArgumentError, 'format is nil' if format.nil?
      raise ArgumentError, 'i18n_key is nil' if i18n_key.nil?
      raise ArgumentError, "format [#{format}] is not :html, :json or :xml" unless [:html, :json, :xml].include?(format)
      raise ArgumentError, 'i18n_args is not a Hash' unless i18n_args.nil? || i18n_args.is_a?(Hash)

      case format
      when :json
        ResourceMessageBuilder.to_json_errors(resource, i18n_key, i18n_args)
      when :xml
        ResourceMessageBuilder.to_xml_errors(resource, i18n_key, i18n_args)
      else
        ResourceMessageBuilder.to_html_errors(resource, i18n_key, i18n_args)
      end
    end

    def self.html_tag_helper
      ActionController::Base.helpers
    end

    def self.to_html_errors(resource, i18n_key, i18n_args)
      return '' if resource.errors.empty?

      caption = ResourceMessageBuilder.i18n_translate(i18n_key, i18n_args)
      messages = resource.errors.full_messages.map do |msg|
        ResourceMessageBuilder.html_tag_helper.content_tag(:li, msg)
      end

      html = <<-HTML
        <div class="panel panel-danger">
          <div class="panel-heading clearfix">
            <div class="panel-title pull-left" style="font-weight: bold; width: 90%;">#{caption}</div>
            <div class="pull-right"><i class='fa fa-times-circle fa-md fa-2x'></i></div>
          </div>
          <div class="panel-body alert-danger">
            #{ messages.join }
          </div>
        </div>
      HTML

      html.html_safe
    end

    def self.to_json_errors(resource, i18n_key, i18n_args)
      raise NotImplementedError
    end

    def self.to_xml_errors(resource, i18n_key, i18n_args)
      raise NotImplementedError
    end

    # Helper methods

    def self.i18n_translate(i18n_key = 'errors.messages.generic', i18n_args = {})
      if i18n_args.nil? || i18n_args.empty?
        caption = I18n.translate(i18n_key)
      else
        caption = I18n.translate(i18n_key, **i18n_args)
      end
    end
  end
#end
