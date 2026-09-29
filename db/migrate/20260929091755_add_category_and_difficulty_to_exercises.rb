class AddCategoryAndDifficultyToExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :exercises, :category, :integer, null: false
    add_column :exercises, :difficulty, :integer, null: false

    add_check_constraint(
      :exercises,
      "difficulty BETWEEN 1 AND 3",
      name: "exercises_difficulty_range"
    )
  end
end
