class GenerateWorkoutJob < ApplicationJob
  queue_as :default
  retry_on WorkoutGenerator::GenerationError, attempts: 2

  def perform(user:, focus:, difficulty:, requested_duration_seconds:)
    WorkoutGenerator.new(user: user, focus: focus, difficulty: difficulty, requested_duration_seconds: requested_duration_seconds).call
  end
end
