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
    redirect_to generating_workouts_path
  end

  def show
    @workout = current_user.workouts.find(params[:id])
  end

  def generating
  end


  private
    def workout_params
      params.expect(workout: [ :difficulty, :requested_duration_seconds, focus: [] ])
    end
end
