require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  setup do
    @exercise = Exercise.new(
      name: "Test Exercise",
      category: :power,
      difficulty: 3
    )
  end

  test "is valid with valid attributes" do
    assert @exercise.valid?
  end

  test "is valid with difficulty 1" do
    @exercise.difficulty = 1
    assert @exercise.valid?
  end

  test "is invalid with difficulty 0" do
    @exercise.difficulty = 0
    assert_not @exercise.valid?
  end

  test "is invalid with difficulty 4" do
    @exercise.difficulty = 4
    assert_not @exercise.valid?
  end

  test "is invalid with category jumping" do
    @exercise.category = "jumping"
    assert_not @exercise.valid?
  end
end
