class User < ApplicationRecord
  include RoleNames

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, email: true
  validates :user_name, user_name: true
  #validates :name, length: { minimum: 3, maximum: 32,
  #  too_long: "Name must be less than or equal to %{count} characters" }, allow_blank: true

  has_many :user_roles, dependent: :delete_all
  has_many :roles, through: :user_roles

  has_many :task_times, dependent: :delete_all

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
    query = <<-SQL
      select distinct
        company.name,
        project.name,
        task.name,
        task_time.duration,
        task_time.id,
        task_time.note,
        task_time.start_time
        from users as "user"
        join task_times task_time on task_time.user_id = "user".id
        join tasks task on task.id = task_time.task_id
        join projects project on project.id = task.project_id
        join companies company on company.id = project.company_id
        where "user".id = #{self.id}
        order by company.name, project.name, task.name
    SQL

    user_task_times_array = []

    ActiveRecord::Base.connection.execute(query).values.each do |e|
      #puts "\n#{e[0]}, #{e[1]}, #{e[2]}, #{e[3]}, #{e[4]}, #{e[5]}, #{e[6]}, #{e[7]}, #{e[8]}"
      user_task_times_array <<
        UserTaskTimes.new(
          e[0], # Company
          e[1], # Project
          e[2], # Task name
          e[3].to_i, # Duration
          e[4].to_i, # Task time id
          e[5], # Task time note
          e[6].present?) # Task time started
    end

    user_task_times_array
  end
end
