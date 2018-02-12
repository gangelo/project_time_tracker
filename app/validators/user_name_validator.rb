class UserNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present?
      record.errors[attribute] << (options[:message] || "is required and must be between 3 and 16 characters")
    end
    unless value.length >= 3 && value.length <= 16
      record.errors[attribute] << (options[:message] || "must be between 3 and 16 characters")
    end

    unless value.match(/\A(?!.*__)(?=.*[^_0-9])(?=.*^[_a-zA-Z0-9]*$).{0,}\z/)
      record.errors[attribute] << (options[:message] || "must contain the characters a-z (upper or lowercase) and may optionally contain 0-9 and/or single, non-consecutive underscore characters ('_')")
    end

    if value.match(/\A[_]|[_]\z/)
      record.errors[attribute] << (options[:message] || "must not begin or end with an underscore character ('_')")
    end

    # Registering users cannot choose a user_name that is already taken
    if record.id == nil
      unless User.where("user_name ILIKE ?", value).count == 0
        record.errors[attribute] << (options[:message] || "has already been taken")
      end
    end

    # Existing users cannot change their user_name to a user_name that is already taken
    if record.id != nil
      unless User.where("id <> ? AND user_name ILIKE ?", record.id, value).count == 0
        record.errors[attribute] << (options[:message] || "has already been taken")
      end
    end
  end
end
