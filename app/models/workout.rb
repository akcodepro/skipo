class Workout < ApplicationRecord
  DIFFICULTY_LEVELS = { 1 => "Easy", 2 => "Medium", 3 => "Hard" }.freeze

  belongs_to :user

  has_many :workout_exercises, -> { order(:position) }, dependent: :destroy
  has_many :exercises, through: :workout_exercises
  has_many :workout_sessions, dependent: :destroy
  has_many :shared_workouts, through: :workout_sessions

  validates :focus, presence: true
  validates :title, presence: true, length: { maximum: 150 }
  validates :difficulty, presence: true, numericality: { only_integer: true }, inclusion: { in: DIFFICULTY_LEVELS.keys }
  validates :requested_duration_seconds, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :allowed_focus_names

  def total_duration_seconds
    workout_exercises.sum do |workout_exercise|
      workout_exercise.duration_seconds + workout_exercise.rest_seconds
    end
  end

  private

  def allowed_focus_names
    return if focus.blank?

    invalid = focus - Exercise.categories.keys

    unless invalid.empty?
      errors.add(:focus, "contains unknown categories: #{invalid.join(", ")}")
    end
  end
end
