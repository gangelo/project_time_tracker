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
  @admin_role = Role.create!(name: 'admin') if @admin_role.nil?
  @user_role = Role.create!(name: 'user') if @user_role.nil?
end

# Admin
def create_admin
  admin = User.new(email: "admin@gmail.com", password: "password")
  admin.confirmed_at = DateTime.now
  admin.roles << @user_role
  admin.roles << @admin_role
  admin.save!
end

# Users
case Rails.env
when 'development'
  total_users = 150
when 'test'
  total_users = 10
else
  total_users = 0
end

if total_users > 0
  ActiveRecord::Base.transaction do
    create_roles
    create_admin
    (0...10).each do |i|
      user = User.new(email: "user#{i}@gmail.com", password: "password")
      user.roles << @user_role
      user.confirmed_at = DateTime.now
      user.save!
    end
  end
end
