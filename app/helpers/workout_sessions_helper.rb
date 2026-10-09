module WorkoutSessionsHelper
  def timer_exercises(workout)
    workout.workout_exercises.map do |workout_exercise| {
      name: workout_exercise.exercise.name,
      work: workout_exercise.duration_seconds,
      rest: workout_exercise.rest_seconds
    }
    end
  end
end
