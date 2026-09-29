class Exercise < ApplicationRecord
  has_many :workout_exercises, dependent: :restrict_with_error
  has_many :workouts, through: :workout_exercises

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }

  enum :category, {
    fundamentals: 0,
    footwork: 1,
    rhythm_coordination: 2,
    power: 3,
    technical: 4,
    freestyle: 5
  }, validate: true

  validates :difficulty, presence: true, numericality: { only_integer: true, in: 1..3 }
end
