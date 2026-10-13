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
    @exercise = Exercise.create!(
      name: "Test Bounce",
      category: :fundamentals,
      difficulty: 2
    )

    WorkoutExercise.create!(
      workout: @workout,
      exercise: @exercise,
      position: 1,
      duration_seconds: 300,
      rest_seconds: 60
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

  test "completes your own session" do
    patch workout_session_path(@workout_session), params: {
      workout_session: {
        status: "completed",
        actual_duration_seconds: 300
      }
    }
    assert_redirected_to workout_session_path(@workout_session)
    @workout_session.reload
    assert_equal "completed", @workout_session.status
    assert_not_nil @workout_session.completed_at
    assert_equal 300, @workout_session.actual_duration_seconds
  end

  test "cannot update someone else's session" do
    patch workout_session_path(@other_session), params: {
      workout_session: {
        status: "completed",
        actual_duration_seconds: 300
      }
    }
    assert_response :not_found
    @other_session.reload
    assert_equal "in_progress", @other_session.status
  end

  test "rejects an invalid status" do
    patch workout_session_path(@workout_session), params: {
      workout_session: {
        status: "in_progress",
        actual_duration_seconds: 300
      }
    }
    assert_redirected_to workout_session_path(@workout_session)
    @workout_session.reload
    assert_equal "in_progress", @workout_session.status
    assert_nil @workout_session.completed_at
  end

  test "clamps actual duration to the workout's total duration" do
    total_duration = @workout_session.workout.total_duration_seconds
    patch workout_session_path(@workout_session), params: {
      workout_session: {
        status: "completed",
        actual_duration_seconds: 999999
      }
    }
    assert_redirected_to workout_session_path(@workout_session)
    @workout_session.reload
    assert_equal total_duration, @workout_session.actual_duration_seconds
  end
end
