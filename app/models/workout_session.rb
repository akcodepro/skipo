class WorkoutSession < ApplicationRecord
  belongs_to :user
  belongs_to :workout

  has_one :shared_workout, dependent: :destroy

  enum :status, {
    in_progress: "in_progress",
    completed: "completed",
    stopped: "stopped"
    }, validate: true

  validates :status, presence: true

  scope :resumable, -> { in_progress.where(started_at: 1.hour.ago..) }
end
