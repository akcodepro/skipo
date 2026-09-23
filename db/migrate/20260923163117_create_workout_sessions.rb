class CreateWorkoutSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_sessions do |t|
      t.string :status, null: false, limit: 30
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :actual_duration_seconds
      t.references :user, null: false, foreign_key: true
      t.references :workout, null: false, foreign_key: true
        
      t.timestamps
    end
  end
end
