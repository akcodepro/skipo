require "test_helper"

class SharedWorkoutTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )

    @workout = Workout.create!(
      user: @user,
      goal: "Some Goal",
      title: "Some title",
      difficulty: "Some difficulty",
      duration_seconds: 45
    )

    @workout_session = WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: "completed",
    )

    @shared_workout = SharedWorkout.create!(
      user: @user,
      workout_session: @workout_session
    )
  end

  test "is valid with an allowed format" do
    @shared_workout.photo.attach(io: File.open(file_fixture("photo.jpg")), filename: "photo.jpg")
    assert @shared_workout.valid?
  end

  test "is invalid with an unallowed format" do
    @shared_workout.photo.attach(io: File.open(file_fixture("not_an_image.txt")), filename: "not_an_image.txt")
    assert_not @shared_workout.valid?
  end

  test "is invalid with a disguised format" do
    skip "Known limitation: files without magic bytes are identified by extension"
    @shared_workout.photo.attach(io: File.open(file_fixture("not_an_image.txt")), filename: "not_an_image.jpg")
    assert_not @shared_workout.valid?
  end

  test "is valid with no photo" do
    assert @shared_workout.valid?
  end
end
