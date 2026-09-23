class CreateSharedWorkouts < ActiveRecord::Migration[8.1]
  def change
    create_table :shared_workouts do |t|
      t.text :caption
      t.string :photo_url, limit: 500
      t.references :user, null: false, foreign_key: true
      t.references :workout_session, null: false, foreign_key: true, index: { unique: true }
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
