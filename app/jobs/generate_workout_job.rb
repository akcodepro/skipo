class GenerateWorkoutJob < ApplicationJob
  queue_as :default
  retry_on WorkoutGenerator::GenerationError, attempts: 2 do | job, error |
    user = job.arguments.first[:user]

    Turbo::StreamsChannel.broadcast_replace_to(
      [ user, :workout_generation ],
      target: "workout_generation",
      partial: "workouts/generation_failed"
    )
  end

  def perform(user:, focus:, difficulty:, requested_duration_seconds:)
    workout = WorkoutGenerator.new(user: user, focus: focus, difficulty: difficulty, requested_duration_seconds: requested_duration_seconds).call

    Turbo::StreamsChannel.broadcast_replace_to(
      [ user, :workout_generation ],
      target: "workout_generation",
      partial: "workouts/generated",
      locals: { workout: workout }
    )
  end
end
