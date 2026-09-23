class CreateWorkoutExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_exercises do |t|
      t.integer :position, null: false
      t.integer :duration_seconds
      t.integer :repetitions
      t.integer :rest_seconds
      t.references :workout, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true

      t.timestamps
    end

    add_index :workout_exercises, [:workout_id, :position], unique: true
  end
end
