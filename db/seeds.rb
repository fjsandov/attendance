puts 'Starting seeding the database...'

puts 'Creating users...'
User.create!(
  name: 'Administrator',
  email: 'admin@example.org',
  password: 'admin1234',
  password_confirmation: 'admin1234',
  admin: true
)

john = User.create!(
  name: 'John Doe',
  email: 'john-doe@example.org',
  password: 'johndoe1234',
  password_confirmation: 'johndoe1234',
)

jane = User.create!(
  name: 'Jane Doe',
  email: 'jane-doe@example.org',
  password: 'janedoe1234',
  password_confirmation: 'janedoe1234',
)

puts 'Creating periods...'
p1 = john.periods.create!(started_at: 1.year.ago, ended_at: 1.year.ago + 4.hours)
john.periods.create!(started_at: p1.started_at + 1.day, ended_at: p1.ended_at + 1.day)

jane.periods.create!(started_at: Time.current, ended_at: 4.hours.from_now)

puts 'Deleting a period'
p1.create_period_deletion(user: p1.user, reason: 'Jane was using my account by mistake')

puts 'Seeding finished'