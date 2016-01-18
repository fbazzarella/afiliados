# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def truncate_tables!
  %w(campaigns emails list_items lists newsletters shot_events shots users).each do |table_name|
    ActiveRecord::Base.connection.execute("delete from #{table_name}")
  end
end

# if Rails.env.development?
  truncate_tables!
  
  User.create({
    username: 'johndoe',
    password: 'secret'
  })
# end
