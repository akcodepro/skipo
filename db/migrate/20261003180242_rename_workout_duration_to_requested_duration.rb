class RenameWorkoutDurationToRequestedDuration < ActiveRecord::Migration[8.1]
  def change
    rename_column :workouts, :duration_seconds, :requested_duration_seconds
  end
end
