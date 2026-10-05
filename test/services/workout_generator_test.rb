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
    @generator.stub(:generate, fake_ai_answer) do
      assert_difference("Workout.count", 1) do
        workout = @generator.call
      end
    end

    # 1. the workout has 3 exercises
    assert_equal 3, workout.workout_exercises.count
    # 2. the first one, ordered by position, is Test Footwork Move
    assert_equal "Test Footwork Move", workout.workout_exercises.order(:position).first.exercise.name
  end

  test "scales exercises and rest durations when total workout duration is outside the range but within 20%" do
    workout = nil
    answer = fake_ai_answer.merge("exercises" => [
      { "name" => "Test Footwork Move",   "duration_seconds" => 150, "rest_seconds" => 80 },
      { "name" => "Test Power Move",   "duration_seconds" => 150, "rest_seconds" => 80 },
      { "name" => "Test Fundamentals Move", "duration_seconds" => 150, "rest_seconds" => 80 }
    ])

    @generator.stub(:generate, answer) do
      assert_difference("Workout.count", 1) do
        workout = @generator.call
      end
    end

    first_exercise = workout.workout_exercises.order(:position).first

    assert_equal 130, first_exercise.duration_seconds
    assert_equal 70, first_exercise.rest_seconds
  end

  test "rejects a workout more than 20% off and saves nothing" do
    answer = fake_ai_answer.merge("exercises" => [
      { "name" => "Test Footwork Move",     "duration_seconds" => 130, "rest_seconds" => 130 },
      { "name" => "Test Power Move",        "duration_seconds" => 130, "rest_seconds" => 130 },
      { "name" => "Test Fundamentals Move", "duration_seconds" => 130, "rest_seconds" => 130 }
    ])

    @generator.stub(:generate, answer) do
      assert_no_difference("Workout.count") do
        assert_raises(WorkoutGenerator::GenerationError) do
          @generator.call
        end
      end
    end
  end

  test "rejects a unknown exercise" do
    answer = fake_ai_answer.merge("exercises" => [
      { "name" => "Test Footwork Move",     "duration_seconds" => 120, "rest_seconds" => 60 },
      { "name" => "Test Power Move",        "duration_seconds" => 120, "rest_seconds" => 60 },
      { "name" => "This exercise is unknown", "duration_seconds" => 120, "rest_seconds" => 120 }
    ])

    @generator.stub(:generate, answer) do
      assert_no_difference("Workout.count") do
        assert_raises(WorkoutGenerator::GenerationError) do
          @generator.call
        end
      end
    end
  end

  test "rejects more than 50% fundamentals category" do
    answer = fake_ai_answer.merge("exercises" => [
      { "name" => "Test Fundamentals Move",     "duration_seconds" => 120, "rest_seconds" => 60 },
      { "name" => "Test Fundamentals Move",     "duration_seconds" => 120, "rest_seconds" => 60 },
      { "name" => "Test Power Move",        "duration_seconds" => 120, "rest_seconds" => 120 }
    ])

    @generator.stub(:generate, answer) do
      assert_no_difference("Workout.count") do
        assert_raises(WorkoutGenerator::GenerationError) do
          @generator.call
        end
      end
    end
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
