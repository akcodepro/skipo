module WorkoutSessionsHelper
  COMPLETED_MESSAGES = [
    "Rope's tired. You're not.",
    "That one's in the bank.",
    "Another good session in the books.",
    "Well, that was time well spent.",
    "Solid effort. Nice work.",
    "You showed up and got it done."
  ].freeze

  STOPPED_MESSAGES = [
    "Every minute counts.",
    "Showing up is the hard part.",
    "A little work is still good work.",
    "Progress doesn't need a perfect session.",
    "You got some good work in.",
    "There's always another session."
  ].freeze

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

  def axis_label(bars, index)
    return "Now" if index == bars.length - 1

    date = bars[index].first
    previous = bars[index - 1].first if index.positive?

    date.strftime("%b") if previous.nil? || previous.month != date.month
  end

  def finish_message(workout_session)
    messages = workout_session.stopped? ? STOPPED_MESSAGES : COMPLETED_MESSAGES
    messages.sample
  end
end
