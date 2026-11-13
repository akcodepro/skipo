require "test_helper"

class SharedWorkoutsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )
    sign_in @user

    # Two workouts with different titles, so we can tell them apart on the page
    workout_a = @user.workouts.create!(
      title: "Morning fundamentals",
      requested_duration_seconds: 900,
      focus: [ "fundamentals" ],
      difficulty: 2
    )
    workout_b = @user.workouts.create!(
      title: "Afternoon strength",
      requested_duration_seconds: 300,
      focus: [ "fundamentals", "power" ],
      difficulty: 3
    )

    # A post needs a session, so each workout gets one
    session_a = WorkoutSession.create!(
      user: @user,
      workout: workout_a,
      status: "completed",
      actual_duration_seconds: 900
    )
    session_b = WorkoutSession.create!(
      user: @user,
      workout: workout_b,
      status: "completed",
      actual_duration_seconds: 300
    )

    # One visible post, one soft-deleted post
    SharedWorkout.create!(user: @user, workout_session: session_a)
    SharedWorkout.create!(user: @user, workout_session: session_b, deleted_at: Time.current)
  end

  test "feed shows visible posts and hides deleted ones" do
    get shared_workouts_path

    assert_response :success
    assert_select ".feed-post__title", text: "Morning fundamentals"
    assert_select ".feed-post__title", text: "Afternoon strength", count: 0
  end
end
