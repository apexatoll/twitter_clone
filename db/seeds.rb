User.create!(
  name: "Example User", 
  email: "example@rails.com", 
  password: "foobar", 
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

99.times do |i|
  User.create!(
    name: Faker::Name.name,
    email: "example-#{i+1}@rails.com", 
    password: "password",
    password_confirmation: "password",
    activated: true,
    activated_at: Time.zone.now
  )
end
