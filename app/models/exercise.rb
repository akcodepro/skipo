class Exercise < ApplicationRecord
  has_many :workout_exercises, dependent: :restrict_with_error
  has_many :workouts, through: :workout_exercises
end
