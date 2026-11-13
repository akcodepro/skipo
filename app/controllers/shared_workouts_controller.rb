class SharedWorkoutsController < ApplicationController
  def index
    @shared_workouts = SharedWorkout
      .visible
      .includes(
        :likes,
        workout_session: {
          workout: {
            workout_exercises: :exercise
          }
        },
        user: { profile_photo_attachment: :blob }
      )
      .order(created_at: :desc)
  end
end
