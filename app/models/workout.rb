class Workout < ApplicationRecord
  belongs_to :user

  has_many :workout_exercises, dependent: :destroy
  has_many :exercises, through: :workout_exercises
  has_many :workout_sessions, dependent: :destroy
  has_many :shared_workouts, through: :workout_sessions

  validates :focus, presence: true
  validates :title, presence: true, length: { maximum: 150 }
  validates :difficulty, presence: true, numericality: { only_integer: true, in: 1..3 }
  validates :requested_duration_seconds, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :allowed_focus_names

  private

  def allowed_focus_names
    return if focus.blank?

    invalid = focus - Exercise.categories.keys

    unless invalid.empty?
      errors.add(:focus, "contains unknown categories: #{invalid.join(", ")}")
    end
  end
end
