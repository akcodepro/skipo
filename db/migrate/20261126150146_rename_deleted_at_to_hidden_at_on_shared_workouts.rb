class RenameDeletedAtToHiddenAtOnSharedWorkouts < ActiveRecord::Migration[8.1]
  def change
    rename_column :shared_workouts, :deleted_at, :hidden_at
  end
end
