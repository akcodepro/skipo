class WorkoutSessionsController < ApplicationController
  def index
  end

  def create
    workout = current_user.workouts.find(params[:workout_id])
    workout_session = workout.workout_sessions.create!(
      user: current_user,
      status: :in_progress,
      started_at: Time.current
    )
    redirect_to workout_session_path(workout_session)
  end

  def show
    @workout_session = current_user.workout_sessions.find(params[:id])
  end
end
