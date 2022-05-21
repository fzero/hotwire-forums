# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Default users ---------------------------------------------------------------
users = [
  {
    email: 'admin@test.com',
    username: 'admin',
    password: 'supersecret',
    password_confirmation: 'supersecret',
    admin: true
  },
  {
    email: 'test@test.com',
    username: 'test',
    password: 'hunter2',
    password_confirmation: 'hunter2'
  }
]
User.delete_all
User.create!(users)

# Default categories ----------------------------------------------------------
# Category model has a bunch of callbacks and we don't want
# to trigger those right now
categories = %w[General Shitposts SrsBsns].map do |name|
  {
    name:,
    created_at: Time.new,
    updated_at: Time.new
  }
end
Category.delete_all
Category.insert_all!(categories)
