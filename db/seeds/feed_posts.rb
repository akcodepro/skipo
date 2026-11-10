puts ""
puts "🌱 Seeding feed posts..."

created_count = 0

FIRST_NAMES.each do |name|
  user = User.find_by!(email: "#{name.downcase}@example.com")
  user.workouts.destroy_all

  # Pick 2 or 3 distinct days within the last 3 weeks
  sessions = rand(2..3)
  days = (1..21).to_a.sample(sessions)

  days.each do |day|
    # Generate a realistic session time
    started_at = day.days.ago.change(
      hour: [ 8, 12, 17, 18, 20 ].sample,
      min: 0,
      sec: 0
    )

    # Pick a random workout template
    template = DEMO_TEMPLATES.sample

    # Create workout and session
    session = create_demo_session(
      user: user,
      template: template,
      started_at: started_at,
      status: :completed
    )

    # Share the completed session
    SharedWorkout.create!(
      user: user,
      workout_session: session
    )

    created_count += 1
  end
end

puts "  🆕 #{created_count} feed posts created."
puts "  📊 #{SharedWorkout.count} total shared workouts."
