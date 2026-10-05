class WorkoutGenerator
  class GenerationError < StandardError; end

  MAX_ADJUSTMENT = 0.2

  MODEL = "mistral-small-latest"
  PROVIDER = :mistral

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

  MAX_FUNDAMENTALS_SHARE = 0.5

  def initialize(user:, focus:, difficulty:, requested_duration_seconds:)
    @user = user
    @focus = focus
    @difficulty = difficulty
    @requested_duration_seconds = requested_duration_seconds
  end

  def call
    result = adjust_timings(generate)
    validate!(result)
    save!(result)
  end

  private

  def candidate_exercises
    @candidate_exercises ||= Exercise.where(category: @focus | [ "fundamentals" ], difficulty: ..@difficulty)
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
    <<~PROMPT
      Target duration: aim for #{@requested_duration_seconds} seconds (acceptable range: #{duration_range.min} to #{duration_range.max} seconds).
      Difficulty: #{@difficulty}
      Focus: #{@focus.join(", ")}

      Available exercises:
      #{ exercise_list }
    PROMPT
  end

  def exercise_list
    candidate_exercises.map { |exercise| "- #{ exercise.name } (#{ exercise.category }, difficulty #{ exercise.difficulty }): #{ exercise.description }" }.join("\n")
  end

  def duration_range
    tolerance = DURATION_TOLERANCES.fetch(@requested_duration_seconds)

    minimum_duration = @requested_duration_seconds - tolerance[:below]
    maximum_duration = @requested_duration_seconds + tolerance[:above]

    minimum_duration..maximum_duration
  end

  def generate
    response = RubyLLM
      .chat(model: MODEL, provider: PROVIDER)
      .with_instructions(INSTRUCTIONS)
      .with_schema(schema)
      .ask(request_message)

    JSON.parse(response.content)
  end

  def total_duration(result)
    result["exercises"].sum do |exercise|
      exercise["duration_seconds"] + exercise["rest_seconds"]
    end
  end

  def fundamentals_share(result)
    fundamental_names = candidate_exercises.fundamentals.pluck(:name)

    fundamentals_count = result["exercises"].count do |exercise|
      fundamental_names.include?(exercise["name"])
    end

    fundamentals_count.to_f / result["exercises"].size
  end

  def validate!(result)
    exercises = result["exercises"]
    raise GenerationError, "Workout must contain at least one exercise" if exercises.empty?

    exercise_names = candidate_exercises.pluck(:name)
    invalid_exercises = exercises
      .map { |exercise| exercise["name"] }
      .uniq
      .difference(exercise_names)
    raise GenerationError, "Workout contains unknown exercises: #{invalid_exercises.join(", ")}" unless invalid_exercises.empty?

    total = total_duration(result)
    range = duration_range
    raise GenerationError, "Workout duration #{ total }s is outside the expected range #{ range.min }–#{ range.max }s" unless range.cover?(total)

    share = fundamentals_share(result)
    raise GenerationError, "Fundamentals make up #{ (share * 100).round(1) }% of exercises; maximum is #{ (MAX_FUNDAMENTALS_SHARE * 100).round }%" if share > MAX_FUNDAMENTALS_SHARE
  end

  def save!(result)
    ActiveRecord::Base.transaction do
      workout = Workout.create!(
        user: @user,
        title: result["title"],
        description: result["description"],
        focus: @focus,
        difficulty: @difficulty,
        requested_duration_seconds: @requested_duration_seconds
      )

      exercises_by_name = candidate_exercises.index_by(&:name)

      result["exercises"].each.with_index(1) do |item, position|
        workout.workout_exercises.create!(
          exercise: exercises_by_name[item["name"]],
          position: position,
          duration_seconds: item["duration_seconds"],
          rest_seconds: item["rest_seconds"]
        )
      end

      workout
    end
  end

  def adjust_timings(result)
    total = total_duration(result)
    range = duration_range
    deviation = (total - @requested_duration_seconds).abs.to_f / @requested_duration_seconds

    # already in range
    return result if range.cover?(total)

    # off by more than 20% => validate! will reject
    return result if deviation > MAX_ADJUSTMENT

    # Otherwise, scale every value
    factor = @requested_duration_seconds.to_f / total

    result.merge(
      "exercises" => result["exercises"].map do |exercise|
        exercise.merge(
          "duration_seconds" => round_to_nearest_five(exercise["duration_seconds"] * factor),
          "rest_seconds" => round_to_nearest_five(exercise["rest_seconds"] * factor)
        )
      end
    )
  end

  def round_to_nearest_five(seconds)
    (seconds / 5.0).round * 5
  end
end
