# Exercise category definitions:
#
# fundamentals:
#   Foundational rope skills and basic jumping patterns.
#
# footwork:
#   Changes in stance, stepping pattern, and movement.
#
# rhythm_coordination:
#   Distinct timing and sequencing patterns that require coordination
#   beyond basic footwork.
#
# power:
#   Speed- or explosiveness-focused exercises, regardless of
#   technical difficulty.
#
# technical:
#   Specific rope-handling tricks and transitions.
#
# freestyle:
#   Creative rope manipulation and distinct, recognizable tricks.
#
# Difficulty measures skill required, not physical intensity.
# Difficulty 1 = Easy, 2 = Medium, 3 = Hard.
puts "🌱 Seeding exercises..."

exercises = [
  # Fundamentals
  { name: "Basic Bounce", category: :fundamentals, difficulty: 1, description: "A simple two-foot jump performed with a steady, controlled rhythm." },
  { name: "Alternate Foot Step", category: :fundamentals, difficulty: 1, description: "A light jog in place over the rope, landing on one foot at a time." },
  { name: "Front-to-Back", category: :fundamentals, difficulty: 1, description: "Two-foot jumps moving slightly forward and back over an imaginary line." },
  { name: "Single Leg Hop", category: :fundamentals, difficulty: 2, description: "Consecutive jumps on one foot to build balance and ankle strength." },

  # Footwork
  { name: "Boxer Step", category: :footwork, difficulty: 1, description: "A relaxed shift of weight from foot to foot, the classic boxing rhythm." },
  { name: "Side-to-Side", category: :footwork, difficulty: 1, description: "Two-foot jumps moving slightly left and right with each turn of the rope." },
  { name: "In & Out", category: :footwork, difficulty: 1, description: "Feet land apart, then together, alternating with each jump." },
  { name: "Skier", category: :footwork, difficulty: 1, description: "Feet together, hopping side to side like a slalom skier." },
  { name: "Running Step", category: :footwork, difficulty: 2, description: "A running motion over the rope, with a steady, quick cadence." },
  { name: "High Knees", category: :footwork, difficulty: 2, description: "A running step with knees driven up to hip height." },

  # Rhythm & Coordination
  { name: "Counted Rhythm Switch", category: :rhythm_coordination, difficulty: 1, description: "A repeating sequence of three basic-bounce jumps followed by three alternate-foot steps." },
  { name: "Double Bounce", category: :rhythm_coordination, difficulty: 1, description: "Two small bouncing actions for each rope rotation, using a light rebound while maintaining control of the rope." },
  { name: "Heel-Toe", category: :rhythm_coordination, difficulty: 2, description: "Alternately tapping one heel forward, then the toe back, between jumps." },
  { name: "Scissors", category: :rhythm_coordination, difficulty: 2, description: "Feet land split front and back, switching legs on every jump." },
  { name: "Cross-Step", category: :rhythm_coordination, difficulty: 2, description: "Legs cross on landing, then uncross on the next jump." },
  { name: "Shuffle", category: :rhythm_coordination, difficulty: 2, description: "Quick, light side-to-side foot shuffles in time with the rope." },

  # Power
  { name: "Fast Basic Bounce", category: :power, difficulty: 1, description: "Basic-bounce skipping at a brisk, controlled pace." },
  { name: "Fast Boxer Step", category: :power, difficulty: 1, description: "Boxer-step skipping at a brisk pace with light, continuous weight shifts." },
  { name: "Speed Step", category: :power, difficulty: 2, description: "An alternate foot step at maximum speed, for short bursts." },
  { name: "Backward Speed Step", category: :power, difficulty: 2, description: "Alternate-foot skipping with backward rope rotation at a brisk, controlled pace." },
  { name: "Double Under", category: :power, difficulty: 3, description: "A jump where the rope passes under your feet twice.", instructions: "Jump slightly higher than normal while keeping your body upright. Rotate the rope quickly with your wrists so it passes under your feet twice before you land. Land softly on the balls of your feet and repeat." },
  { name: "Triple Under", category: :power, difficulty: 3, description: "A single high jump with three rope passes, for advanced jumpers." },

  # Technical
  { name: "Side Swing Jump", category: :technical, difficulty: 1, description: "A transition from a side swing into a forward rope rotation and jump." },
  { name: "Backward Basic Bounce", category: :technical, difficulty: 1, description: "A basic bounce performed while rotating the rope backward." },
  { name: "Criss-Cross", category: :technical, difficulty: 2, description: "Arms cross in front of the body on alternate jumps, then uncross." },
  { name: "Side Swing Cross", category: :technical, difficulty: 2, description: "A side swing followed straight away by a jump with arms crossed." },
  { name: "EB", category: :technical, difficulty: 3, description: "One arm crosses in front of the body while the other crosses behind." },
  { name: "Toad", category: :technical, difficulty: 3, description: "One arm crosses under the opposite raised leg as you jump." },

  # Freestyle
  { name: "Side Swing", category: :freestyle, difficulty: 1, description: "The rope swings to one side of the body without a jump. Useful as active rest." },
  { name: "Side Swing to Boxer Step", category: :freestyle, difficulty: 1, description: "A transition from a side swing into continuous boxer-step skipping." },
  { name: "Leg Over", category: :freestyle, difficulty: 3, description: "One leg lifts over a handle as the rope passes, a classic freestyle trick." },
  { name: "360", category: :freestyle, difficulty: 3, description: "A full body spin combined with a side swing and jump." }
]

created_count = 0
updated_count = 0
unchanged_count = 0

exercises.each do |exercise_attributes|
  exercise = Exercise.find_or_initialize_by(name: exercise_attributes[:name])
  is_new_exercise = exercise.new_record?

  exercise.assign_attributes(exercise_attributes)
  has_changes = exercise.changed?

  exercise.save!

  if is_new_exercise
    created_count += 1
  elsif has_changes
    updated_count += 1
  else
    unchanged_count += 1
  end
end

puts "  ✅ Exercise seeding complete!"
puts "  🆕 #{created_count} new exercises created."
puts "  ✏️  #{updated_count} existing exercises updated."
puts "  ⏭️  #{unchanged_count} exercises unchanged."
puts "  📚 #{Exercise.count} exercises in the database."

#############################
#############################
#############################
#############################
#############################

# Create or find demo user
demo_user = User.find_or_initialize_by(email: "jumper@example.com")

demo_user.assign_attributes(
  display_name: "Jamie",
  password: "letsjump"
)
demo_user.save!

# Clear existing workouts (sessions and exercises are destroyed automatically)
demo_user.workouts.destroy_all

#############################
#############################
#############################
#############################
#############################

DEMO_TEMPLATES = [
  {
    title: "Steady Rhythm Foundations",
    description: "Easy, even pacing to groove the basics. Stay light and keep the rope smooth.",
    focus: ["fundamentals"], difficulty: 1, minutes: 10, work: 45, rest: 30,
    moves: ["Basic Bounce", "Alternate Foot Step", "Front-to-Back", "Boxer Step",
            "Basic Bounce", "Side-to-Side", "Alternate Foot Step", "Basic Bounce"]
  },
  {
    title: "Light Feet Warm-Up",
    description: "Short stepping patterns to wake the ankles up. Smooth beats fast today.",
    focus: ["fundamentals", "footwork"], difficulty: 1, minutes: 10, work: 40, rest: 35,
    moves: ["Basic Bounce", "Boxer Step", "Side-to-Side", "In & Out",
            "Skier", "Alternate Foot Step", "Boxer Step", "Basic Bounce"]
  },
  {
    title: "Rhythm & Power Mix",
    description: "Steady blocks broken up by quick bursts. Push the fast ones, recover on the easy ones.",
    focus: ["fundamentals", "power"], difficulty: 2, minutes: 15, work: 45, rest: 30,
    moves: ["Basic Bounce", "Fast Basic Bounce", "Boxer Step", "Fast Boxer Step",
            "Alternate Foot Step", "Speed Step", "Front-to-Back", "Backward Speed Step",
            "Single Leg Hop", "Speed Step", "Basic Bounce", "Fast Boxer Step"]
  },
  {
    title: "Footwork & Crosses Flow",
    description: "Moving feet and crossing arms, one skill at a time. Reset with a basic bounce when you trip.",
    focus: ["fundamentals", "footwork", "technical"], difficulty: 2, minutes: 20, work: 50, rest: 25,
    moves: ["Boxer Step", "Side-to-Side", "Criss-Cross", "In & Out",
            "Skier", "Side Swing Cross", "Running Step", "Backward Basic Bounce",
            "High Knees", "Criss-Cross", "Basic Bounce", "Side Swing Jump",
            "Boxer Step", "Running Step", "Criss-Cross", "Alternate Foot Step"]
  },
  {
    title: "Double Under Challenge",
    description: "Coordination patterns building up to double unders. Quality first, then speed.",
    focus: ["fundamentals", "power", "rhythm_coordination"], difficulty: 3, minutes: 15, work: 45, rest: 30,
    moves: ["Basic Bounce", "Heel-Toe", "Speed Step", "Scissors",
            "Double Under", "Cross-Step", "Speed Step", "Shuffle",
            "Double Under", "Single Leg Hop", "Scissors", "Fast Basic Bounce"]
  }
].freeze

created_workouts = 0
created_sessions = 0
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

    days = ([today_offset] + days).uniq
  end

  days.each do |day_offset|
    session_date = week_start + day_offset.days

    time_slots = [8, 12, 17, 18, 20]

    if current_week && session_date.to_date == Date.current
      time_slots = time_slots.select do |hour|
        session_date + hour.hours <= Time.current
      end

      # Monday at 07:00: guarantee a past time
      time_slots = [6] if time_slots.empty?
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
