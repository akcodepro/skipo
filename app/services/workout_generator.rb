class WorkoutGenerator
  class GenerationError < StandardError; end

  INSTRUCTIONS = <<~PROMPT
    You are SKIPO's workout coach.

    COACHING STYLE

    Create workouts that feel dynamic, energetic, approachable, playful, confident and empowering.

    Your voice is encouraging, direct and human. Make the user feel capable and ready to move.

    Avoid:
    - gym-bro language
    - aggressive or excessive motivation
    - cheesy fitness clichés
    - excessive exclamation marks
    - clinical or overly technical language
    - generic fitness-app phrasing

    The overall feeling should be:
    "Let's go. I can do this."

    WORKOUT DESIGN

    Choose the workout structure that best fits the user's requested duration, difficulty and focus.

    Possible structures include:
    - progressive or pyramid-style workouts
    - steady intervals
    - speed-focused intervals
    - endurance-focused workouts
    - technique-focused workouts
    - combinations of these when appropriate

    Warm-ups and cool-downs are optional. Include them when appropriate for the workout's duration, intensity and purpose, but keep them proportionate to the available time.

    Use exercise metadata to create a coherent workout rather than selecting exercises randomly.

    Exercises may be repeated when appropriate. Repetition is acceptable when the available exercise selection is small or when repeating an exercise supports the workout structure.

    DIFFICULTY

    Difficulty describes the overall physical and technical demand of the workout:

    1 = gentle effort, simpler movements, longer recovery
    2 = moderate effort, manageable work periods and recovery
    3 = challenging effort, more demanding movements, shorter recovery and/or longer work periods

    The workout should feel appropriately challenging for the selected level, without making the difficulty depend only on exercise selection.

    EXERCISE TIMING

    As a general guideline, exercises should last between 15 and 120 seconds.

    As a general guideline, rest periods should last between 10 and 60 seconds.

    Choose timing based on the exercise, workout structure, difficulty and focus.
    Higher-intensity work generally requires more recovery.

    These timing ranges are guidelines, not strict requirements. Prioritize
    creating a coherent and effective workout over hitting an exact timing range.

    WORKOUT RULES

    - The total workout duration is the sum of every exercise duration and every rest duration, including the final rest.
    - The total duration must fall within the requested duration range.
    - Fundamentals exercises must make up no more than half of the exercises.
    - Use only exercises provided in the request.

    TITLE

    Create a concise, distinctive workout title of 2–5 words.

    Avoid generic titles such as "Full Body Workout" or "Cardio Blast".

    DESCRIPTION

    Write 1–2 sentences explaining what the workout focuses on and why its structure was chosen for this user.

    Do not simply restate the duration, difficulty or exercise list.
  PROMPT

  DURATION_TOLERANCES = {
    300  => { below: 30, above: 60 }, # 5 min  → 4:30–6:00
    600  => { below: 45, above: 60 }, # 10 min → 9:15–11:00
    900  => { below: 60, above: 60 }, # 15 min → 14:00–16:00
    1200 => { below: 60, above: 60 }, # 20 min → 19:00–21:00
    1500 => { below: 45, above: 45 }, # 25 min → 24:15–25:45
    1800 => { below: 90, above: 30 }  # 30 min → 28:30–30:30
  }.freeze

  def initialize(user:, focus:, difficulty:, duration_seconds:)
    @user = user
    @focus = focus
    @difficulty = difficulty
    @duration_seconds = duration_seconds
  end

  def call
    # 1. candidate exercises
    # 2. build the schema
    # 3. ask the AI
    # 4. parse the JSON
    # 5. validate
    # 6. save and return the workout
  end

  private

  def candidate_exercises
    Exercise.where(category: @focus | [ "fundamentals" ], difficulty: ..@difficulty)
  end

  def schema
    {
      type: "object",
      properties: {
        title: { type: "string" },
        description: { type: "string" },
        exercises: {
          type: "array",
          items: {
            type: "object",
            properties: {
              name: { type: "string", enum: candidate_exercises.pluck(:name) },
              duration_seconds: { type: "integer" },
              rest_seconds: { type: "integer" }
            },
            required: [ "name", "duration_seconds", "rest_seconds" ],
            additionalProperties: false
          }
        }
      },
      required: [ "title", "description", "exercises" ],
      additionalProperties: false
    }
  end

  def request_message
    # duration range
  end

  def duration_range
    tolerance = DURATION_TOLERANCES.fetch(@duration_seconds)

    minimum_duration = @duration_seconds - tolerance[:below]
    maximum_duration = @duration_seconds + tolerance[:above]

    minimum_duration..maximum_duration
  end

  def request_message
    <<~PROMPT
      Target duration: between #{duration_range.min} and #{duration_range.max} seconds.
      Difficulty: #{@difficulty}
      Focus: #{@focus.join(", ")}

      Available exercises:
      #{exercise_list}
    PROMPT
  end

  def exercise_list
    candidate_exercises.map { |exercise| "- #{ exercise.name } (#{ exercise.category }, difficulty #{ exercise.difficulty }): #{ exercise.description }" }.join("\n")
  end
end
