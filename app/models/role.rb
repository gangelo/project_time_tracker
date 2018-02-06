class Role < ApplicationRecord
  include RoleNames

  validates_presence_of :name, message: 'is required'
  validates_uniqueness_of :name, message: 'is already taken', case_sensitive: false

  has_many :user_roles
  has_many :users, through: :user_roles

  scope :admin, -> { select(:id, :name).find_by(name: ADMIN_ROLE_NAME) }
  scope :user, -> { select(:id, :name).find_by(name: USER_ROLE_NAME) }
end
