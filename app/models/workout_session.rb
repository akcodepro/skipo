class WorkoutSession < ApplicationRecord
  belongs_to :user
  belongs_to :workout

  has_one :shared_workout, dependent: :destroy
end
