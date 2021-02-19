# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Click.delete_all
Url.delete_all

data = [
  { short_url: '123', original_url: 'http://google.com', created_at: Time.now },
  { short_url: '456', original_url: 'http://facebook.com', created_at: Time.now },
  { short_url: '789', original_url: 'http://yahoo.com', created_at: Time.now }
]

data.each do |item|
  url = Url.create(item)

  Random.rand(5..250).times do
    Click.create({
                   url: url,
                   browser: Faker::Internet.user_agent,
                   platform: Faker::Computer.platform,
                   created_at: Faker::Date.backward({ days: 30 * 6 })
                 })
  end
end
