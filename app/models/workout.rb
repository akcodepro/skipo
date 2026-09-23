class Workout < ApplicationRecord
  belongs_to :user

  has_many :workout_exercises, dependent: :destroy
  has_many :exercises, through: :workout_exercises
  has_many :workout_sessions, dependent: :destroy
  has_many :shared_workouts, through: :workout_sessions
end
