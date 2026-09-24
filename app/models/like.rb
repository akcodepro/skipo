class Like < ApplicationRecord
  belongs_to :user
  belongs_to :shared_workout

  validates :user_id, uniqueness: { scope: :shared_workout_id }
end
