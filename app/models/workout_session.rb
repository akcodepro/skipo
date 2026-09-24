class WorkoutSession < ApplicationRecord
  belongs_to :user
  belongs_to :workout

  has_one :shared_workout, dependent: :destroy

  enum :status, {
    in_progress: "in_progress",
    paused: "paused",
    completed: "completed",
    abandoned: "abandoned"
    }, validates: true

  validates :status, presence: true
end
