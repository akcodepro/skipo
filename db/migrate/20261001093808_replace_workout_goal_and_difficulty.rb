class ReplaceWorkoutGoalAndDifficulty < ActiveRecord::Migration[8.1]
  def change
    remove_column :workouts, :goal, :string, limit: 50, null: false
    remove_column :workouts, :difficulty, :string, limit: 30, null: false

    add_column :workouts, :focus, :string, array: true, default: [], limit: 50, null: false
    add_column :workouts, :difficulty, :integer, null: false

    add_check_constraint :workouts, "difficulty BETWEEN 1 AND 3", name: "workouts_difficulty_range"
  end
end
