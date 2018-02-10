class User < ApplicationRecord
  include RoleNames

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, email: true
  validates :user_name, user_name: true
  #validates :name, length: { minimum: 3, maximum: 32}, message: "Name must be between 3 and 32 characters"

  has_many :user_roles, dependent: :delete_all
  has_many :roles, through: :user_roles

  has_many :task_times

  scope :admins, -> { joins(:roles).where("roles.name = '#{ADMIN_ROLE_NAME}'") }
  scope :non_admins, -> {
    where.not(id: User.joins(:roles).select(:id).where("roles.name = '#{ADMIN_ROLE_NAME}'")) }

  # TODO: Move this to helper and change params to UserSearchCriteria param.
  def self.find_by_search_criteria_with_paginate(search_option, search_string, paginate_params = { page: nil, per_page: nil }, user = nil)
    users = find_by_search_criteria(search_option, search_string, user)
    users = users.paginate(page: paginate_params[:page], per_page: paginate_params[:per_page])
  end

  # TODO: Move this to helper and change params to UserSearchCriteria param.
  def self.find_by_search_criteria(search_option, search_string, user = nil)
    return User.none unless search_option.presence && search_string.presence
    # search_option must be a valid, whitelisted column on the users table.
    raise ArgumentError unless ['email', 'user_name'].include?(search_option)
    User.where("users.#{search_option} ILIKE ?", "%#{search_string}%")
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

  def all_task_times
    user_task_times_array = []
    self.task_times.each do |t|
      task_times_id = t.id
      company_name = t.task.project.company.name
      project_name = t.task.project.name
      task_name = t.task.name
      task_duration = t.duration || 0
      task_start_time = t.start_time

      user_task_times_array << UserTaskTimes.new(task_times_id,
        company_name, project_name, task_name, task_duration, task_start_time)
    end
    user_task_times_array = user_task_times_array.sort_by { |obj| obj.sort_field } unless user_task_times_array.empty?
    user_task_times_array
  end
end
