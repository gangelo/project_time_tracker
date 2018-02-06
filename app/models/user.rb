class User < ApplicationRecord
  include RoleNames

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, email: true
  validates :user_name, user_name: true

  has_many :user_roles, dependent: :delete_all
  has_many :roles, through: :user_roles

  scope :admins, -> { joins(:roles).where("roles.name = '#{ADMIN_ROLE_NAME}'") }
  scope :non_admins, -> {
    where.not(id: User.joins(:roles).select(:id).where("roles.name = '#{ADMIN_ROLE_NAME}'")) }

  # Is the user in the user role?
  def user?
    role?(:user)
  end

  # Is the user in the admin role?
  def admin?
    role?(:admin)
  end

  # Returns true if the user is in role.
  def role?(role)
    return false if role.blank? || self.roles.count == 0
    return false unless role.is_a?(String) || role.is_a?(Symbol)
    role = role.to_s if role.is_a?(Symbol)
    self.roles.exists?(name: role.downcase)
  end
end
