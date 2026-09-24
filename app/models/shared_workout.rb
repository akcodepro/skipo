class SharedWorkout < ApplicationRecord
  belongs_to :user
  belongs_to :workout_session

  has_many :likes, dependent: :destroy

  validates :workout_session_id, uniqueness: true
end
