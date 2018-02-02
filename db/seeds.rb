# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(0...200).each do |i|
  email = i == 0 ? "admin@gmail.com" : "user#{i}@gmail.com"
  user = User.create({ email: email, password: "password" })
  user.confirmed_at = DateTime.now
  user.save!
end
