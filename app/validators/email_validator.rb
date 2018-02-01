class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.present?
      record.errors[attribute] << (options[:message] || "is required")
      return
    end

    unless value.length >= 3 && value.length <= 254
      record.errors[attribute] << (options[:message] || "must be between 3 and 254 characters")
    end

    unless value.match(/@/)
      record.errors[attribute] << (options[:message] || "must be a valid email address")
    end

    # Registering users cannot choose an email that is already being used
    if record.id != nil
      unless User.where("id <> ? AND email ILIKE ?", record.id, value).count == 0
        record.errors[attribute] << (options[:message] || "is already being used")
      end
    end

    # Existing users cannot change their email address to an email address that is already being used
    if record.id == nil
      unless User.where("email ILIKE ?", value).count == 0
        record.errors[attribute] << (options[:message] || "is already being used")
      end
    end
  end
end
