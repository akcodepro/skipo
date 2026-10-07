require "test_helper"

class WorkoutsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )
    sign_in @user
  end

  test "submitting the train form enqueues a generation job and redirects" do
    assert_enqueued_with(job: GenerateWorkoutJob) do
      post workouts_path, params: {
        workout: {
          requested_duration_seconds: 600,
          focus: [ "fundamentals" ],
          difficulty: 3
        }
      }
    end

    assert_redirected_to generating_workouts_path
  end

  test "shows the user's own workout" do
    workout = @user.workouts.create!(
      title: "Morning Strength",
      description: "A quick strength workout",
      requested_duration_seconds: 600,
      focus: [ "fundamentals" ],
      difficulty: 2
    )

    get workout_path(workout)

    assert_response :success
    assert_select "h1", workout.title
  end

  test "does not show another user's workout" do
    other_user = User.create!(
      display_name: "Jamie",
      email: "jamie@example.com",
      password: "password123"
    )

    their_workout = other_user.workouts.create!(
      title: "Jamie's Workout",
      description: "A private workout",
      requested_duration_seconds: 600,
      focus: [ "fundamentals" ],
      difficulty: 2
    )

    get workout_path(their_workout)

    assert_response :not_found
  end
end
