class Workout < ApplicationRecord
  belongs_to :user

  has_many :workout_exercises, dependent: :destroy
  has_many :exercises, through: :workout_exercises
  has_many :workout_sessions, dependent: :destroy
  has_many :shared_workouts, through: :workout_sessions

  validates :goal, presence: true, length: { maximum: 50 }
  validates :title, presence: true, length: { maximum: 150 }
  validates :difficulty, presence: true, length: { maximum: 30 }
  validates :duration_seconds, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
