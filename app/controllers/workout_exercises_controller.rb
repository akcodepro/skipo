class WorkoutExercisesController < ApplicationController
  def show
    workout = current_user.workouts.find(params[:workout_id])
    @workout_exercise = workout.workout_exercises.find(params[:id])
  end
end
