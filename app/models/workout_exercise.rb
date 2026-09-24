class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise

  validates :position, presence: true, numericality: { greater_than: 0 }
  validates :duration_seconds, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :repetitions, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :rest_seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  validate :duration_or_repetitions_present

  private

  def duration_or_repetitions_present
    return if duration_seconds.present? || repetitions.present?

    errors.add(
      :base,
      "must have either duration_seconds or repetitions"
    )
  end
end
