require "test_helper"
require "minitest/mock"
require "turbo/broadcastable/test_helper"

class GenerateWorkoutJobTest < ActiveJob::TestCase
  include Turbo::Broadcastable::TestHelper

  setup do
    @user = User.create!(display_name: "Alex", email: "alex@example.com", password: "password123")
    @workout = Workout.create!(
      user: @user, title: "Test Workout", focus: [ "footwork" ],
      difficulty: 2, requested_duration_seconds: 600
    )
  end

  test "broadcasts the generated workout on success" do
    fake_generator = Minitest::Mock.new
    fake_generator.expect(:call, @workout)

    WorkoutGenerator.stub(:new, ->(**) { fake_generator }) do
      assert_turbo_stream_broadcasts [ @user, :workout_generation ], count: 1 do
        GenerateWorkoutJob.perform_now(
          user: @user, focus: [ "footwork" ], difficulty: 2, requested_duration_seconds: 600
        )
      end
    end

    fake_generator.verify
  end

  test "broadcasts a failure message when retries run out" do
    WorkoutGenerator.stub(:new, ->(**) { raise WorkoutGenerator::GenerationError, "AI failed" }) do
      assert_turbo_stream_broadcasts [ @user, :workout_generation ], count: 1 do
        perform_enqueued_jobs do
          GenerateWorkoutJob.perform_later(
            user: @user, focus: [ "footwork" ], difficulty: 2, requested_duration_seconds: 600
          )
        end
      end
    end
  end
end
