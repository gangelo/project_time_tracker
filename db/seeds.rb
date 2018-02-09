# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@total_users = 0
@admin_role = nil
@user_role = nil

# Roles
def create_roles
  @admin_role = Role.create!(name: Role::ADMIN_ROLE_NAME) if @admin_role.nil?
  @user_role = Role.create!(name: Role::USER_ROLE_NAME) if @user_role.nil?
end

# Admin
def create_admin
  admin = User.new(email: "admin@gmail.com", user_name: "admin", password: "password")
  admin.confirmed_at = DateTime.now
  admin.roles << @user_role
  admin.roles << @admin_role
  admin.save!
end

case Rails.env
when 'development'
  @total_users = 25
when 'test'
  @total_users = 10
else
  @total_users = 0
end

# Users
if @total_users > 0
  ActiveRecord::Base.transaction do
    create_roles
    create_admin
    (0...@total_users).each do |i|
      user = User.new(email: "user#{i}@gmail.com", user_name: "user_name#{i}", password: "password")
      user.roles << @user_role
      user.confirmed_at = DateTime.now
      user.save!
    end
  end
end

# Company
company = Company.create!(name: "CoverMyMeds")

# Add project to company
#byebug
company.projects << Project.create!(name: "Time Tracker", company: company)
company.save!
#byebug

time_tracker_project = Project.first
time_tracker_project.tasks << Task.create(name: "Design")
time_tracker_project.tasks << Task.create(name: "Coding")
time_tracker_project.tasks << Task.create(name: "Debugging")
time_tracker_project.save!
