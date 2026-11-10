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

# Build a workout, its exercises and its session from a template.
def create_demo_session(user:, template:, started_at:, status: :completed)
  workout = user.workouts.create!(
    title: template[:title],
    description: template[:description],
    focus: template[:focus],
    difficulty: template[:difficulty],
    requested_duration_seconds: template[:minutes] * 60,
    created_at: started_at - 5.minutes
  )

  template[:moves].each_with_index do |move, index|
    exercise = Exercise.find_by!(name: move)

    workout.workout_exercises.create!(
      exercise: exercise,
      position: index + 1,
      duration_seconds: template[:work],
      rest_seconds: index == template[:moves].length - 1 ? 0 : template[:rest]
    )
  end

  actual_duration = if status == :stopped
    (workout.total_duration_seconds * 0.7).round
  else
    workout.total_duration_seconds
  end

  workout.workout_sessions.create!(
    user: user,
    status: status,
    started_at: started_at,
    actual_duration_seconds: actual_duration,
    completed_at: started_at + actual_duration.seconds
  )
end
