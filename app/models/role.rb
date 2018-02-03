class Role < ApplicationRecord
  validates_presence_of :name, message: 'is required'
  validates_uniqueness_of :name, message: 'is already taken', case_sensitive: false
end
