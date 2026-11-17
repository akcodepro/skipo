class LikesController < ApplicationController
  before_action :set_shared_workout

  def create
    @shared_workout.likes.create(user: current_user)
    respond_with_like_button
  end

  def destroy
    like = @shared_workout.likes.find_by(user: current_user)
    like&.destroy
    respond_with_like_button
  end

  private
    def set_shared_workout
      @shared_workout = SharedWorkout.visible.find(params[:shared_workout_id])
    end

    def respond_with_like_button
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            helpers.dom_id(@shared_workout, :like),
            partial: "shared_workouts/like_button",
            locals: { shared_workout: @shared_workout }
          )
        end

        format.html { redirect_to shared_workouts_path }
      end
    end
end
