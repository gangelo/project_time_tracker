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

  def self.find_by_search_criteria_with_paginate(search_option, search_string, paginate_params = { page: nil, per_page: nil }, user = nil)
    users = find_by_search_criteria(search_option, search_string, user)
    users = users.paginate(page: paginate_params[:page], per_page: paginate_params[:per_page])
  end

  # !!!WARNING This needs to be sanitized WARNING!!!
  def self.find_by_search_criteria(search_option, search_string, user = nil)
    return User.none unless search_option.presence && search_string.presence

    option = User.arel_table[search_option]
    User.where(option.matches("%#{search_string}%"))
=begin
    in_clause = build_sql_in_clause(:skills, :name, skills)
    UserProfile.joins(:skills).where(in_clause)
      .group('user_profiles.id')
      .having("COUNT(user_profiles.id) >= ? AND COUNT(user_profiles.id) <= ?", from_count(skills.count), skills.count)
      .order("COUNT(user_profiles.id) DESC, user_profiles.id")
      .reject{ |p|
        # Filter out user profiles that the current user is connected with, or, has
        # outstanding connect requests against.
        (p.user_id == user.id || user.connect_requests.where(request_user_id: p.user_id).any?) if user.presence && true
      }
=end
  end

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
