# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def create_companies_and_projects(company_name, project_name)
  # Company
  company = Company.create!(name: company_name)

  if project_name.is_a?(Array)
    projects = []

    project_name.each_with_index do |n, i|
      project = Project.create!(name: n, company: company)
      project.tasks << Task.create(name: "Design#{i}")
      project.tasks << Task.create(name: "Coding#{i}")
      project.tasks << Task.create(name: "Debugging#{i}")
      project.tasks << Task.create(name: "Miscellaneous#{i}")
      project.save!
      projects << project
    end

    company.save!

    { company: company, project: projects}
  else
    company.projects << Project.create!(name: project_name, company: company)
    project = Project.first
    project.tasks << Task.create(name: "Design")
    project.tasks << Task.create(name: "Coding")
    project.tasks << Task.create(name: "Debugging")
    project.tasks << Task.create(name: "Miscellaneous")
    project.save!

    company.save!

    { company: company, project: project}
  end
end

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
  project_info = create_companies_and_projects("CoverMyMeds", "Time Tracker")
  project = project_info[:project]

  ActiveRecord::Base.transaction do
    create_roles
    create_admin
    (0...@total_users).each do |i|
      user = User.new(email: "user#{i}@gmail.com", user_name: "user_name#{i}", password: "password")
      user.roles << @user_role
      user.confirmed_at = DateTime.now
      user.save!

      project.tasks.each do |t|
        user.task_times << TaskTime.create(task: t)
      end
      user.save!
    end
  end
end

create_companies_and_projects("Facebook", ["FB User Privacy", "FB Rewards"])
create_companies_and_projects("Twitter",  ["T User Privacy", "T Rewards"])
create_companies_and_projects("Hulu",  ["H User Privacy", "H Rewards"])
