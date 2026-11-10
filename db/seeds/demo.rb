# Create or find demo user
demo_user = User.find_or_initialize_by(email: "jumper@example.com")

demo_user.assign_attributes(
  display_name: "Jamie",
  password: "letsjump"
)
demo_user.save!

# Clear existing workouts (exercises, sessions, shared posts and likes go with them)
demo_user.workouts.destroy_all

created_workouts = 0
missed_weeks = []
templates_used = Hash.new(0)
session_number = 0
completed_sessions = 0
stopped_sessions = 0
total_actual_duration_seconds = 0

13.times do |weeks_back|
  week_start = weeks_back.weeks.ago.beginning_of_week

  # Exactly one deliberate missed week
  if weeks_back == 5
    missed_weeks << week_start.to_date
    next
  end

  current_week = weeks_back.zero?

  available_days =
    if current_week
      (0..(Date.current - week_start.to_date).to_i).to_a
    else
      (0..6).to_a
    end

  sessions = rand(1..3)
  days = available_days.sample(sessions)

  # Guarantee one completed session in the current week
  if current_week
    today_offset = (Date.current - week_start.to_date).to_i

    days = ([ today_offset ] + days).uniq
  end

  days.each do |day_offset|
    session_date = week_start + day_offset.days

    time_slots = [ 8, 12, 17, 18, 20 ]

    if current_week && session_date.to_date == Date.current
      time_slots = time_slots.select do |hour|
        session_date + hour.hours <= Time.current
      end

      # Monday at 07:00: guarantee a past time
      time_slots = [ 6 ] if time_slots.empty?
    end

    session_time = session_date + time_slots.sample.hours

    next if session_time > Time.current

    # Pick a random workout template
    template = DEMO_TEMPLATES.sample

    session_number += 1
    status = (session_number % 6).zero? ? :stopped : :completed

    # Create workout, exercises and session
    session = create_demo_session(
      user: demo_user,
      template: template,
      started_at: session_time,
      status: status
    )

    actual_duration = session.actual_duration_seconds

    if status == :stopped
      stopped_sessions += 1
    else
      completed_sessions += 1
    end

    total_actual_duration_seconds += actual_duration
    created_workouts += 1
    templates_used[template[:title]] += 1
  end
end

puts ""
puts "🏋️  Demo workout seeding complete!"
puts "  👤 Demo user: #{demo_user.display_name} (#{demo_user.email})"
puts "  🆕 #{created_workouts} workouts created."
puts "  ✅ #{completed_sessions} completed sessions."
puts "  🛑 #{stopped_sessions} stopped sessions."
puts "  📅 #{13 - missed_weeks.size} weeks with workout history."
puts "  💤 #{missed_weeks.size} deliberately missed week(s)."
puts "  ⏱️  #{(total_actual_duration_seconds / 60.0).round} minutes of actual workout time."
puts ""
puts "  📚 Workout template distribution:"

templates_used.sort.each do |title, count|
  puts "    • #{title}: #{count}"
end

puts ""
puts "  📊 #{demo_user.workouts.count} total workouts for demo user."
