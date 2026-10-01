require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )

    @workout = Workout.new(
      user: @user,
      title: "Test workout",
      focus: [ "freestyle", "power" ],
      difficulty: 3,
      duration_seconds: 780
    )
  end

  test "is valid with valid attributes" do
    assert @workout.valid?
  end

  test "is invalid with nil focus" do
    @workout.focus = nil
    assert_not @workout.valid?
  end

  test "is invalid with empty focus" do
    @workout.focus = []
    assert_not @workout.valid?
  end

  test "is invalid with unknown focus category" do
    @workout.focus = [ "power", "creative" ]
    assert_not @workout.valid?
  end

  test "is invalid with difficulty out of range: 4" do
    @workout.difficulty = 4
    assert_not @workout.valid?
  end

  test "is invalid with difficulty out of range: 0" do
    @workout.difficulty = 0
    assert_not @workout.valid?
  end
end
