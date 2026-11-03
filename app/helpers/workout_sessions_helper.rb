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

  def session_date(time)
    return "Today" if time.to_date == Date.current

    time.strftime("%a %-d %b")
  end

  def first_moves(workout, count: 2)
    names = workout.workout_exercises.map { |workout_exercise| workout_exercise.exercise.name }
    shown = names.first(count)
    hidden = names.size - shown.size

    shown << "+#{hidden}" if hidden.positive?
    shown.join(" · ")
  end
end
