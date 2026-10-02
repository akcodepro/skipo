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
end
