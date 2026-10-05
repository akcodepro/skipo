require "test_helper"
require "minitest/mock"

class WorkoutGeneratorTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )
    @exercises = Exercise.create!(
      [
        {
          name: "Test Fundamentals Move",
          category: :fundamentals,
          difficulty: 1
        },
        {
          name: "Test Footwork Move",
          category: :footwork,
          difficulty: 1
        },
        {
          name: "Test Power Move",
          category: :power,
          difficulty: 2
        }
      ]
    )
    @generator = WorkoutGenerator.new(user: @user, focus: [ "footwork", "power" ], difficulty: 2, requested_duration_seconds: 600)
  end

  test "saves a workout with its exercises in order" do
    workout = nil
    # ACT: fake the AI, then press the button
    @generator.stub(:generate, fake_ai_answer) do
      assert_difference("Workout.count", 1) do
        workout = @generator.call
      end
    end

    # ASSERT: check what got saved

    # 1. the workout has 3 exercises
    assert_equal 3, workout.workout_exercises.count
    # 2. the first one, ordered by position, is Test Footwork Move
    assert_equal "Test Footwork Move", workout.workout_exercises.order(:position).first.exercise.name
  end

  private

  def fake_ai_answer
    {
      "title" => "Test Workout",
      "description" => "A fake AI answer for testing.",
      "exercises" => [
      { "name" => "Test Footwork Move",   "duration_seconds" => 120, "rest_seconds" => 60 },
      { "name" => "Test Power Move",   "duration_seconds" => 120, "rest_seconds" => 60 },
      { "name" => "Test Fundamentals Move", "duration_seconds" => 120, "rest_seconds" => 120 }
      ]
    }
  end
end
