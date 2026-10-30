# Create or find demo user
demo_user = User.find_or_initialize_by(email: "jumper@example.com")

demo_user.assign_attributes(
  display_name: "Jamie",
  password: "letsjump"
)
demo_user.save!

# Clear existing workouts (sessions and exercises are destroyed automatically)
demo_user.workouts.destroy_all

DEMO_TEMPLATES = [
  {
    title: "Steady Rhythm Foundations",
    description: "Easy, even pacing to groove the basics. Stay light and keep the rope smooth.",
    focus: [ "fundamentals" ], difficulty: 1, minutes: 10, work: 45, rest: 30,
    moves: [ "Basic Bounce", "Alternate Foot Step", "Front-to-Back", "Boxer Step",
            "Basic Bounce", "Side-to-Side", "Alternate Foot Step", "Basic Bounce" ]
  },
  {
    title: "Light Feet Warm-Up",
    description: "Short stepping patterns to wake the ankles up. Smooth beats fast today.",
    focus: [ "fundamentals", "footwork" ], difficulty: 1, minutes: 10, work: 40, rest: 35,
    moves: [ "Basic Bounce", "Boxer Step", "Side-to-Side", "In & Out",
            "Skier", "Alternate Foot Step", "Boxer Step", "Basic Bounce" ]
  },
  {
    title: "Rhythm & Power Mix",
    description: "Steady blocks broken up by quick bursts. Push the fast ones, recover on the easy ones.",
    focus: [ "fundamentals", "power" ], difficulty: 2, minutes: 15, work: 45, rest: 30,
    moves: [ "Basic Bounce", "Fast Basic Bounce", "Boxer Step", "Fast Boxer Step",
            "Alternate Foot Step", "Speed Step", "Front-to-Back", "Backward Speed Step",
            "Single Leg Hop", "Speed Step", "Basic Bounce", "Fast Boxer Step" ]
  },
  {
    title: "Footwork & Crosses Flow",
    description: "Moving feet and crossing arms, one skill at a time. Reset with a basic bounce when you trip.",
    focus: [ "fundamentals", "footwork", "technical" ], difficulty: 2, minutes: 20, work: 50, rest: 25,
    moves: [ "Boxer Step", "Side-to-Side", "Criss-Cross", "In & Out",
            "Skier", "Side Swing Cross", "Running Step", "Backward Basic Bounce",
            "High Knees", "Criss-Cross", "Basic Bounce", "Side Swing Jump",
            "Boxer Step", "Running Step", "Criss-Cross", "Alternate Foot Step" ]
  },
  {
    title: "Double Under Challenge",
    description: "Coordination patterns building up to double unders. Quality first, then speed.",
    focus: [ "fundamentals", "power", "rhythm_coordination" ], difficulty: 3, minutes: 15, work: 45, rest: 30,
    moves: [ "Basic Bounce", "Heel-Toe", "Speed Step", "Scissors",
            "Double Under", "Cross-Step", "Speed Step", "Shuffle",
            "Double Under", "Single Leg Hop", "Scissors", "Fast Basic Bounce" ]
  }
].freeze

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

    # Create workout
    workout = demo_user.workouts.create!(
      title: template[:title],
      description: template[:description],
      focus: template[:focus],
      difficulty: template[:difficulty],
      requested_duration_seconds: template[:minutes] * 60,
      created_at: session_time - 5.minutes
    )

    # Create workout exercises
    template[:moves].each_with_index do |move, index|
      exercise = Exercise.find_by!(name: move)

      workout.workout_exercises.create!(
        exercise: exercise,
        position: index + 1,
        duration_seconds: template[:work],
        rest_seconds: index == template[:moves].length - 1 ? 0 : template[:rest]
      )
    end

    # Create session
    started_at = session_time

    session_number += 1
    stopped = (session_number % 6).zero?

    actual_duration = stopped ?
      (workout.total_duration_seconds * 0.7).round :
      workout.total_duration_seconds

    workout.workout_sessions.create!(
      user: demo_user,
      status: stopped ? :stopped : :completed,
      started_at: started_at,
      actual_duration_seconds: actual_duration,
      completed_at: started_at + actual_duration.seconds
    )

    if stopped
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
