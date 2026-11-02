module WorkoutSessionsHelper
  def timer_exercises(workout)
    workout.workout_exercises.map do |workout_exercise| {
      name: workout_exercise.exercise.name,
      work: workout_exercise.duration_seconds,
      rest: workout_exercise.rest_seconds
    }
    end
  end

  def human_duration(seconds)
    return "0 min" if seconds.nil?

    minutes = (seconds / 60.0).round
    hours = minutes / 60
    remaining_minutes = minutes % 60

    if hours.positive? && remaining_minutes.positive?
      "#{hours}h #{remaining_minutes}min"
    elsif hours.positive?
      "#{hours}h"
    else
      "#{minutes} min"
    end
  end
end
