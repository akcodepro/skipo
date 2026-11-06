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

  test "seconds_by week groups session durations by week" do
    week_one = Date.new(2026, 10, 5)
    week_two = Date.new(2026, 10, 12)

    WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: :completed,
      started_at: week_one + 1.day,
      actual_duration_seconds: 300
    )

    WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: :completed,
      started_at: week_one + 3.days,
      actual_duration_seconds: 600
    )

    WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: :completed,
      started_at: week_two + 1.day,
      actual_duration_seconds: 900
    )

    result = @user.workout_sessions.finished.seconds_by("week")

    assert_equal({ week_one => 900, week_two => 900 }, result)
  end

  test "counts a session just after Monday midnight in Paris in that week" do
    week_two = Date.new(2026, 10, 12)

    WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: :completed,
      started_at: Time.zone.local(2026, 10, 12, 0, 30),
      actual_duration_seconds: 300
    )

    result = @user.workout_sessions.finished.seconds_by("week")

    assert_equal 300, result[week_two]
    assert_nil result[Date.new(2026, 10, 5)]
  end

  test "bars fill weeks without sessions with zero" do
    week_one = Date.new(2026, 10, 5)

    WorkoutSession.create!(
      user: @user, workout: @workout, status: :completed,
      started_at: Time.zone.local(2026, 10, 6, 18), actual_duration_seconds: 300
    )

    bars = @user.workout_sessions.finished.bars("week", from: week_one)

    assert_equal [ week_one, 300 ], bars.first
    assert_equal [ Date.new(2026, 10, 12), 0 ], bars.second
    assert_equal Date.current.beginning_of_week, bars.last.first
  end

  test "bars start at the first session's month when there is no range start" do
    WorkoutSession.create!(
      user: @user, workout: @workout, status: :completed,
      started_at: Time.zone.local(2026, 8, 20, 18), actual_duration_seconds: 300
    )

    bars = @user.workout_sessions.finished.bars("month")

    assert_equal [ Date.new(2026, 8, 1), 300 ], bars.first
  end

  test "bars are empty with no finished sessions" do
    assert_equal [], @user.workout_sessions.finished.bars("week")
  end

  test "counts a session just after midnight in Paris on that day" do
    day = Date.new(2026, 10, 12)

    WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: :completed,
      started_at: Time.zone.local(2026, 10, 12, 0, 30),
      actual_duration_seconds: 300
    )

    result = @user.workout_sessions.finished.seconds_by("day")

    assert_equal 300, result[day]
    assert_nil result[day - 1]
  end

  test "calendar days include every day through Sunday and fill missing days with zero" do
    start = Date.new(2026, 10, 12)
    finish = Date.current.end_of_week

    WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: :completed,
      started_at: Time.zone.local(2026, 10, 12, 10),
      actual_duration_seconds: 300
    )

    calendar = @user.workout_sessions.finished.calendar_days(from: start)

    assert_equal start, calendar.first.first
    assert_equal finish, calendar.last.first
    assert_equal 0, calendar.length % 7

    assert_equal [ start, 300 ], calendar.first
    assert_equal [ start + 1.day, 0 ], calendar.second
  end
end
