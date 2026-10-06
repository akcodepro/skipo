class WorkoutsController < ApplicationController
  def new
    @workout = Workout.new
  end

  def create
    choices = workout_params
    difficulty = choices[:difficulty].to_i
    focus = choices[:focus].compact_blank
    requested_duration_seconds = choices[:requested_duration_seconds].to_i

    GenerateWorkoutJob.perform_later(
      difficulty: difficulty,
      focus: focus,
      requested_duration_seconds: requested_duration_seconds,
      user: current_user
    )
    redirect_to new_workout_path, notice: "Generating your workout…"
  end

  private
    def workout_params
      params.expect(workout: [ :difficulty, :requested_duration_seconds, focus: [] ])
    end
end
