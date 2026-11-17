class LikesController < ApplicationController
  before_action :set_shared_workout, only: [ :create, :destroy ]

  def create
    @shared_workout.likes.create(user: current_user)
    redirect_to shared_workouts_path
  end

  def destroy
    like = @shared_workout.likes.find_by(user: current_user)
    like&.destroy
    redirect_to shared_workouts_path
  end

  private
    def set_shared_workout
      @shared_workout = SharedWorkout.visible.find(params[:shared_workout_id])
    end
end
