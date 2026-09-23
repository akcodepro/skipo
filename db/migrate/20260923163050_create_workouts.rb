class CreateWorkouts < ActiveRecord::Migration[8.1]
  def change
    create_table :workouts do |t|
      t.string :goal, null: false, limit: 50
      t.string :title, null: false, limit: 150
      t.text :description
      t.string :difficulty, null: false, limit: 30
      t.integer :duration_seconds, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
