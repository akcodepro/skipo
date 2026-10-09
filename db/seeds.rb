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
