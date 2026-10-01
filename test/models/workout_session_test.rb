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
      focus: ["freestyle"],
      title: "Test workout",
      difficulty: 1,
      duration_seconds: 900,
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
end
