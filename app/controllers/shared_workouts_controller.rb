class SharedWorkoutsController < ApplicationController
  before_action :set_workout_session, only: %i[ create ]

  def index
    @shared_workouts = SharedWorkout
      .visible
      .includes(
        :likes,
        photo_attachment: :blob,
        workout_session: {
          workout: {
            workout_exercises: :exercise
          }
        },
        user: { profile_photo_attachment: :blob }
      )
      .order(created_at: :desc)
  end

  def create
    @shared_workout = SharedWorkout.new(shared_workout_params.merge(user: current_user, workout_session: @workout_session))

    if @shared_workout.save
      redirect_to shared_workouts_path, notice: "Shared to the feed."
    else
      redirect_to workout_session_path(@workout_session), alert: @shared_workout.errors.full_messages.first
    end
  end

  private
    def set_workout_session
      @workout_session = current_user.workout_sessions.completed.find(params[:workout_session_id])
    end

    def shared_workout_params
      params.expect(shared_workout: [ :caption, :photo ])
    end
end
