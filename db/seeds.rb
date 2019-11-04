puts 'Starting seeding the database...'

User.create(
  name: 'Administrator',
  email: 'admin@example.org',
  password: 'admin',
  password_confirmation: 'admin',
  admin: true
)

puts 'Seeding finished'