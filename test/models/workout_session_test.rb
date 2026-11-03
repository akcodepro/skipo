require "test_helper"
class WorkoutSessionTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
      )
    @workout = Workout.create!(
      user: @user,
      focus: [ "freestyle" ],
      title: "Test workout",
      difficulty: 1,
      requested_duration_seconds: 900,
      )
  end

  test "is valid with an allowed status" do
    workout_session = WorkoutSession.new(user: @user, workout: @workout, status: "stopped")
    assert workout_session.valid?
  end

  test "is invalid with a status that is not allowed" do
    workout_session = WorkoutSession.new(user: @user, workout: @workout, status: "paused")
    assert_not workout_session.valid?
  end

  test "usual duration and difficulty are the most common among finished sessions" do
    short_hard = Workout.create!(
      user: @user, focus: [ "power" ], title: "Short hard",
      difficulty: 3, requested_duration_seconds: 600
    )

    2.times { WorkoutSession.create!(user: @user, workout: @workout, status: :completed) }
    WorkoutSession.create!(user: @user, workout: short_hard, status: :stopped)
    3.times { WorkoutSession.create!(user: @user, workout: short_hard, status: :in_progress) }

    sessions = @user.workout_sessions.finished

    assert_equal 900, sessions.usual_duration_seconds
    assert_equal 1, sessions.usual_difficulty
  end

  test "usual duration and difficulty are nil with no finished sessions" do
    sessions = @user.workout_sessions.finished

    assert_nil sessions.usual_duration_seconds
    assert_nil sessions.usual_difficulty
  end

  test "focus mix counts picks on top of fundamentals as percentages" do
    footwork = Workout.create!(
      user: @user, focus: [ "fundamentals", "footwork" ], title: "Footwork day",
      difficulty: 1, requested_duration_seconds: 600
    )
    pure = Workout.create!(
      user: @user, focus: [ "fundamentals" ], title: "Pure day",
      difficulty: 1, requested_duration_seconds: 600
    )

    WorkoutSession.create!(user: @user, workout: footwork, status: :completed)
    WorkoutSession.create!(user: @user, workout: pure, status: :stopped)

    mix = @user.workout_sessions.finished.focus_mix

    assert_equal({ "footwork" => 50, "fundamentals_only" => 50 }, mix)
  end

  test "focus mix is empty with no finished sessions" do
    assert_equal({}, @user.workout_sessions.finished.focus_mix)
  end
end
