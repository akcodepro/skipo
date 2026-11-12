class SharedWorkoutsController < ApplicationController
  def index
    @shared_workouts = SharedWorkout
      .includes(
        :likes,
        workout_session: :workout,
        user: { profile_photo_attachment: :blob },
      )
      .order(created_at: :desc)
  end
end
