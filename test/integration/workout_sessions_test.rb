require "test_helper"

class WorkoutSessionsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )
    sign_in @user

    @workout = Workout.create!(
      user: @user,
      title: "Test Workout",
      focus: [ "footwork" ],
      difficulty: 2,
      requested_duration_seconds: 600
    )

    @other_user = User.create!(
      display_name: "Sam",
      email: "sam@example.com",
      password: "password123"
    )

    @other_workout = Workout.create!(
      user: @other_user,
      title: "Their Workout",
      focus: [ "footwork" ],
      difficulty: 2,
      requested_duration_seconds: 600
    )

    @workout_session = WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: :in_progress
    )

    @other_session = WorkoutSession.create!(
      user: @other_user,
      workout: @other_workout,
      status: :in_progress
    )
  end

  test "Starting your own workout creates a session" do
    assert_difference("WorkoutSession.count", 1) do
      post workout_workout_sessions_path(@workout)
    end

    assert_redirected_to workout_session_path(WorkoutSession.last)
  end

  test "Starting someone else's workout returns not found" do
    assert_no_difference("WorkoutSession.count") do
      post workout_workout_sessions_path(@other_workout)
    end

    assert_response :not_found
  end

  test "Viewing your own session shows the workout" do
    get workout_session_path(@workout_session)

    assert_response :success
    assert_select "h1", @workout.title
  end

  test "Viewing someone else's session returns not found" do
    get workout_session_path(@other_session)

    assert_response :not_found
  end
end
