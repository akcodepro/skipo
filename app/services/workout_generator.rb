class WorkoutGenerator
  class GenerationError < StandardError; end

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
end
