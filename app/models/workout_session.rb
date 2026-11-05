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
  scope :finished, -> { where(status: %i[completed stopped]) }

  def self.usual_duration_seconds
    joins(:workout)
      .group("workouts.requested_duration_seconds")
      .count
      .max_by { |_duration, count| count }
      &.first
  end

  def self.usual_difficulty
    joins(:workout)
      .group("workouts.difficulty")
      .count
      .max_by { |_difficulty, count| count }
      &.first
  end

  def self.focus_mix
    counts = joins(:workout)
      .pluck("workouts.focus")
      .flat_map do |focuses|
        if focuses == [ "fundamentals" ]
          [ "fundamentals_only" ]
        else
          focuses - [ "fundamentals" ]
        end
      end
      .tally

    total = counts.values.sum

    percentages = counts.transform_values do |count|
      (count * 100.0 / total).round
    end

    percentages.sort_by { |_focus, percentage| -percentage }.to_h
  end

  def self.seconds_by(unit)
    raise ArgumentError, "Invalid unit" unless %w[week month].include?(unit)

    timezone = Time.zone.tzinfo.name

    group(
      sanitize_sql_array([
        "date_trunc(?, started_at AT TIME ZONE 'UTC' AT TIME ZONE ?)::date",
        unit,
        timezone
      ])
    ).sum(:actual_duration_seconds)
  end
end
